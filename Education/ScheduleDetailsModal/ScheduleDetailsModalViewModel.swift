//
//  ScheduleDetailsModalViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//

import Foundation

class ScheduleDetailsModalViewModel {
    private let subjectManager: SubjectManager
    
    var schedule: Schedule
    var subject: Subject
    var selectedDay: String
    
    init(subjectManager: SubjectManager = SubjectManager(), schedule: Schedule) {
        self.subjectManager = subjectManager
        
        self.schedule = schedule
        self.subject = self.subjectManager.fetchSubject(withID: self.schedule.unwrappedSubjectID)!
        
        let days = [
            String(localized: "sunday"),
            String(localized: "monday"),
            String(localized: "tuesday"),
            String(localized: "wednesday"),
            String(localized: "thursday"),
            String(localized: "friday"),
            String(localized: "saturday")
        ]
        
        self.selectedDay = days[schedule.unwrappedDay]
    }
    
    func getTimeString(isStartTime: Bool) -> String {
        let date = isStartTime ? self.schedule.unwrappedStartTime : self.schedule.unwrappedEndTime
        
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        if let hour = dateComponents.hour,
           let minute = dateComponents.minute {
            let hourText = hour > 9 ? "\(hour)" : "0\(hour)"
            let minuteText = minute > 9 ? "\(minute)" : "0\(minute)"
            
            return hourText + ":" + minuteText
        }
        
        return String()
    }
}


