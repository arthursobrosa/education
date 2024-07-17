//
//  ScheduleViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation

class ScheduleViewModel {
    // MARK: - Subject and Schedule Handlers
    private let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager
    
    // MARK: - Properties
    var schedules = [Schedule]()
    
    var selectedDay: Int = Calendar.current.component(.weekday, from: Date()) - 1
    
    var daysOfWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    // MARK: - Initializer
    init(subjectManager: SubjectManager = SubjectManager(), scheduleManager: ScheduleManager = ScheduleManager()) {
        self.subjectManager = subjectManager
        self.scheduleManager = scheduleManager
    }
    
    // MARK: - Methods
    func fetchSchedules() {
        if let schedules = self.scheduleManager.fetchSchedules(dayOfTheWeek: self.selectedDay) {
            self.schedules = schedules
        }
    }
    
    func removeSchedule(_ schedule: Schedule) {
        self.scheduleManager.deleteSchedule(schedule)
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
}
