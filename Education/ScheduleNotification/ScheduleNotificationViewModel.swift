//
//  ScheduleNotificationViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import Foundation

class ScheduleNotificationViewModel {
    private let subjectManager: SubjectManager
    
    var schedule: Schedule
    var subject: Subject
    
    init(subjectManager: SubjectManager = SubjectManager(), schedule: Schedule) {
        self.subjectManager = subjectManager
        
        self.schedule = schedule
        self.subject = self.subjectManager.fetchSubject(withID: self.schedule.unwrappedSubjectID)!
        
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
