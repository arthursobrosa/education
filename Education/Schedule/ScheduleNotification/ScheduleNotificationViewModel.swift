//
//  ScheduleNotificationViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import Foundation

class ScheduleNotificationViewModel {
    private let subjectManager: SubjectManager

    var startTime: Date
    var endTime: Date
    var subject: Subject

    private let days = [
        String(localized: "sunday"),
        String(localized: "monday"),
        String(localized: "tuesday"),
        String(localized: "wednesday"),
        String(localized: "thursday"),
        String(localized: "friday"),
        String(localized: "saturday"),
    ]

    init(subjectManager: SubjectManager = SubjectManager(), subjectName: String, startTime: Date, endTime: Date) {
        self.subjectManager = subjectManager

        self.startTime = startTime
        self.endTime = endTime

        subject = self.subjectManager.fetchSubject(withName: subjectName)!
    }

    func getTimeString(isStartTime: Bool) -> String {
        let date = isStartTime ? startTime : endTime

        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

        if let hour = dateComponents.hour,
           let minute = dateComponents.minute
        {
            let hourText = hour > 9 ? "\(hour)" : "0\(hour)"
            let minuteText = minute > 9 ? "\(minute)" : "0\(minute)"

            return hourText + ":" + minuteText
        }

        return String()
    }

    func getDayOfWeek() -> String {
        let date = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)

        return days[dayOfWeek - 1]
    }
}
