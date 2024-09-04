//
//  ScheduleViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation
import UIKit

enum ScheduleViewMode: CaseIterable {
    case daily
    case weekly
    
    var name: String {
        switch self {
            case .daily:
                return String(localized: "daily")
            case .weekly:
                return String(localized: "weekly")
        }
    }
}

class ScheduleViewModel {
    // MARK: - Subject and Schedule Handlers
     let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager
    
    // MARK: - Properties
    var schedules = [Schedule]()
    
    var tasks: [[Schedule]] = [[],[],[],[],[],[],[]]
    
    var viewModes: [ScheduleViewMode] = ScheduleViewMode.allCases
    var selectedViewMode: ScheduleViewMode = .daily
    
    var selectedDate: Date = Date() {
        didSet {
            self.selectedWeekday = self.getWeekday(from: selectedDate)
        }
    }
    var selectedWeekday = Int()
    
    lazy var daysOfWeek: [Date] = self.getDaysOfWeek()
    
    var currentFocusSessionModel: FocusSessionModel?
    
    // MARK: - Initializer
    init(subjectManager: SubjectManager = SubjectManager(), scheduleManager: ScheduleManager = ScheduleManager()) {
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
    }
    
    // MARK: - Methods
    func fetchSchedules() {
        if let schedules = self.scheduleManager.fetchSchedules(dayOfTheWeek: self.selectedWeekday) {
            let orderedSchedules = schedules.sorted {
                let calendar = Calendar.current
                let startTimeComponents1 = calendar.dateComponents([.hour, .minute], from: $0.unwrappedStartTime)
                let startTimeComponents2 = calendar.dateComponents([.hour, .minute], from: $1.unwrappedStartTime)
                
                if let hour1 = startTimeComponents1.hour, let minute1 = startTimeComponents1.minute,
                   let hour2 = startTimeComponents2.hour, let minute2 = startTimeComponents2.minute {
                    if hour1 == hour2 {
                        return minute1 < minute2
                    }
                    return hour1 < hour2
                }
                return false
            }
            
            self.schedules = orderedSchedules
        }
        
        if let weekSchedules = self.scheduleManager.fetchSchedules() {
            let orderedWeekSchedules = weekSchedules.sorted {
                let calendar = Calendar.current
                let startTimeComponents1 = calendar.dateComponents([.hour, .minute], from: $0.unwrappedStartTime)
                let startTimeComponents2 = calendar.dateComponents([.hour, .minute], from: $1.unwrappedStartTime)
                
                if let hour1 = startTimeComponents1.hour, let minute1 = startTimeComponents1.minute,
                   let hour2 = startTimeComponents2.hour, let minute2 = startTimeComponents2.minute {
                    if hour1 == hour2 {
                        return minute1 < minute2
                    }
                    return hour1 < hour2
                }
                return false
            }
            
            let schedulesByDay = organizeSchedulesByDayOfWeek(orderedWeekSchedules)
            
            self.tasks = schedulesByDay
        }
        
    }
    
    func organizeSchedulesByDayOfWeek(_ orderedWeekSchedules: [Schedule]) -> [[Schedule]] {
        var schedulesByDay: [[Schedule]] = Array(repeating: [], count: 7)
        
        for schedule in orderedWeekSchedules {
            schedulesByDay[Int(schedule.dayOfTheWeek)].append(schedule)
        }
        
        schedulesByDay = Array(schedulesByDay[UserDefaults.dayOfWeek..<schedulesByDay.count]) + Array(schedulesByDay[0..<UserDefaults.dayOfWeek])
        
        return schedulesByDay
    }
    
    func getSubject(fromSchedule schedule: Schedule) -> Subject? {
        return self.subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID)
    }
    
    func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date).prefix(3).uppercased()
    }
    
    func dayFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: date)
    }
    
    func isThereAnySubject() -> Bool {
        guard let subjects = self.subjectManager.fetchSubjects() else { return false }
        
        return !subjects.isEmpty
    }
    
    func firstThreeLetters(of text: String) -> String {
        return String(text.prefix(3))
    }
    
    func getTitleString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, "
        
        let month = dateFormatter.string(from: Date()).capitalized
        
        dateFormatter.dateFormat = "YYYY"
        
        let year = dateFormatter.string(from: Date()).capitalized
        
        return month + year
    }
    
    private func getDaysOfWeek() -> [Date] {
        let calendar = Calendar.current
        var startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        startOfWeek = calendar.date(byAdding: .day, value: UserDefaults.dayOfWeek, to: startOfWeek)!
        
        var daysOfWeek = (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
        
        if let today = calendar.dateComponents([.day], from: Date()).day,
           let startOfWeekDay = calendar.dateComponents([.day], from: startOfWeek).day {
            
            if startOfWeekDay > today {
                daysOfWeek = daysOfWeek.map { date in
                    guard let day = calendar.dateComponents([.day], from: date).day,
                          day > today,
                          let mappedDate = calendar.date(byAdding: .day, value: -7, to: date) else { return date }
                    
                    return mappedDate
                }
            }
        }
        
        return daysOfWeek
    }
    
    func updateDaysOfWeek() {
        self.daysOfWeek = self.getDaysOfWeek()
    }
    
    func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.weekday, from: date) - 1
        
        let today = calendar.component(.weekday, from: Date()) - 1
        
        return currentDay == today
    }
    
    func getWeekday(from date: Date) -> Int {
        return Calendar.current.component(.weekday, from: date) - 1
    }
}
