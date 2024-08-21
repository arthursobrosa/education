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
    
    init(subjectManager: SubjectManager = SubjectManager(), subjectName: String, startTime: Date, endTime: Date) {
        self.subjectManager = subjectManager
        
        self.startTime = startTime
        self.endTime = endTime
        
        self.subject = self.subjectManager.fetchSubject(withName: subjectName)!
    }
    
    func getTimeString(isStartTime: Bool) -> String {
        let date = isStartTime ? self.startTime : self.endTime
        
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
