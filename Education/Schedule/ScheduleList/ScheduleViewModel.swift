//
//  ScheduleViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation
import UIKit

enum ScheduleMode: CaseIterable {
    case daily
    case weekly

    var name: String {
        switch self {
        case .daily:
            String(localized: "daily")
        case .weekly:
            String(localized: "weekly")
        }
    }
}

class ScheduleViewModel {
    // MARK: - Subject and Schedule Handlers

    let subjectManager: SubjectManager
    private let scheduleManager: ScheduleManager

    // MARK: - Properties

    var schedules = [Schedule]()
    var tasks: [[Schedule]] = [[], [], [], [], [], [], []]
    var scheduleModes: [ScheduleMode] = ScheduleMode.allCases
    var selectedScheduleMode: ScheduleMode = .daily
    var scheduleToBeDeletedIndex: Int = 0

    var selectedDate: Date = .init() {
        didSet {
            selectedWeekday = getWeekday(from: selectedDate)
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
}

// MARK: - Schedule Handling

extension ScheduleViewModel {
    func fetchSchedules() {
        if let schedules = scheduleManager.fetchSchedules(dayOfTheWeek: selectedWeekday) {
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

        if let weekSchedules = scheduleManager.fetchSchedules() {
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

            tasks = schedulesByDay
        }
    }
    
    func removeSchedule() {
        let schedule = schedules[scheduleToBeDeletedIndex]
        scheduleManager.deleteSchedule(schedule)
    }

    func organizeSchedulesByDayOfWeek(_ orderedWeekSchedules: [Schedule]) -> [[Schedule]] {
        var schedulesByDay: [[Schedule]] = Array(repeating: [], count: 7)

        for schedule in orderedWeekSchedules {
            schedulesByDay[Int(schedule.dayOfTheWeek)].append(schedule)
        }

        schedulesByDay = Array(schedulesByDay[UserDefaults.dayOfWeek ..< schedulesByDay.count]) + Array(schedulesByDay[0 ..< UserDefaults.dayOfWeek])

        return schedulesByDay
    }
    
    func getEventCase(for schedule: Schedule?) -> EventCase {
        guard let schedule else { return .notToday }

        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 1

        guard schedule.dayOfTheWeek == today else { return .notToday }

        let components: Set<Calendar.Component> = [.hour, .minute]

        let startTimeComponents = getDateComponents(components, from: schedule.unwrappedStartTime)
        let endTimeComponents = getDateComponents(components, from: schedule.unwrappedEndTime)
        let currentTimeComponents = getDateComponents(components, from: Date())

        guard let startHour = startTimeComponents.hour, let startMinute = startTimeComponents.minute,
              let endHour = endTimeComponents.hour, let endMinute = endTimeComponents.minute,
              let currentHour = currentTimeComponents.hour, let currentMinute = currentTimeComponents.minute
        else {
            return .notToday
        }

        let startTimeInMinutes = startHour * 60 + startMinute
        let endTimeInMinutes = endHour * 60 + endMinute
        let currentTimeInMinutes = currentHour * 60 + currentMinute

        if currentTimeInMinutes < startTimeInMinutes {
            let differenceInMinutes = startTimeInMinutes - currentTimeInMinutes
            let hoursLeft = differenceInMinutes / 60
            let minutesLeft = differenceInMinutes % 60

            return .upcoming(hoursLeft: String(hoursLeft), minutesLeft: String(minutesLeft))
        } else if currentTimeInMinutes <= endTimeInMinutes {
            return .ongoing
        } else {
            if schedule.completed {
                return .completed
            } else {
                return .late
            }
        }
    }
    
    private func getDateComponents(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        let calendar = Calendar.current

        return calendar.dateComponents(components, from: date)
    }
    
    func getShortTimeString(for schedule: Schedule?, isStartTime: Bool) -> String {
        guard let schedule else { return String() }

        let formatter = DateFormatter()
        formatter.timeStyle = .short

        let time = isStartTime ? schedule.unwrappedStartTime : schedule.unwrappedEndTime

        return "\(formatter.string(from: time))"
    }
}

// MARK: - Subject Handling

extension ScheduleViewModel {
    func getSubject(fromSchedule schedule: Schedule) -> Subject? {
        return subjectManager.fetchSubject(withID: schedule.unwrappedSubjectID)
    }
}

// MARK: - Days Handling

extension ScheduleViewModel {
    private func getDaysOfWeek() -> [Date] {
        let calendar = Calendar.current
        guard let baseDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())),
              let startOfWeek = calendar.date(byAdding: .day, value: UserDefaults.dayOfWeek, to: baseDate) else { return [] }

        var daysOfWeek = (0 ..< 7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }

        if let today = calendar.dateComponents([.day], from: Date()).day,
           let startOfWeekDay = calendar.dateComponents([.day], from: startOfWeek).day,
           startOfWeekDay > today {
            
            daysOfWeek = daysOfWeek.map { date in
                guard let day = calendar.dateComponents([.day], from: date).day,
                      day > today,
                      let mappedDate = calendar.date(byAdding: .day, value: -7, to: date) else { return date }

                return mappedDate
            }
        }

        return daysOfWeek
    }
    
    func updateDaysOfWeek() {
        daysOfWeek = getDaysOfWeek()
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
    
    func dayAbbreviation(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date).prefix(3).uppercased()
    }
}

// MARK: - NavigationItem and EmptyView Auxiliar Methods

extension ScheduleViewModel {
    func getTitleString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, "

        let month = dateFormatter.string(from: Date()).capitalized

        dateFormatter.dateFormat = "YYYY"

        let year = dateFormatter.string(from: Date()).capitalized

        return month + year
    }
    
    func getContentViewInfo() -> (isDaily: Bool, isEmpty: Bool) {
        var isDaily = false
        var isEmpty = false

        if selectedScheduleMode == .daily {
            isEmpty = schedules.isEmpty
            isDaily = true
        } else {
            isDaily = false

            var emptyTasks = 0
            for task in tasks where task.isEmpty {
                emptyTasks += 1
            }
            isEmpty = emptyTasks == tasks.count
        }

        return (isDaily, isEmpty)
    }
}
