//
//  ScheduleViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 10/07/24.
//

import Foundation

struct ScheduleTask {
    var id = UUID()
    var dayOfTheWeek: Int
    var startTime: Date
    var endTime: Date
    var subjectName: String
}

class ScheduleViewModel {
    var tasks: [ScheduleTask] = [
        ScheduleTask(dayOfTheWeek: 0, startTime: Date(), endTime: Date().addingTimeInterval(3600), subjectName: "Math"),
        ScheduleTask(dayOfTheWeek: 3, startTime: Date(), endTime: Date().addingTimeInterval(3600), subjectName: "Science"),
        ScheduleTask(dayOfTheWeek: 3, startTime: Date().addingTimeInterval(3600), endTime: Date().addingTimeInterval(7200), subjectName: "Geography")
    ]
    
    var selectedDay: Int = Calendar.current.component(.weekday, from: Date()) - 1
    
    var daysOfWeek: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func tasks(for day: Int) -> [ScheduleTask] {
        return tasks.filter { $0.dayOfTheWeek == day }
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

