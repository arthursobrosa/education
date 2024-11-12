//
//  FocusSubjectDetailsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 07/11/24.
//

import UIKit

class FocusSubjectDetailsViewModel {
    private let focusSessionManager: FocusSessionManager
    var focusSession: FocusSession
    
    var dateString: String = String()
    var hoursString: String = String()
    
    init(focusSession: FocusSession) {
        focusSessionManager = FocusSessionManager()
        self.focusSession = focusSession
    }
    
    func updateFocusSessionComment(){
        
    }
    
    func removeFocusSession(){
        
    }
    
    func getSubjectName(subjectID: String) -> Subject? {
        let subjectManager = SubjectManager()
        return subjectManager.fetchSubject(withID: subjectID) ?? nil
    }
    
    func getDateString() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        let formattedDate = dateFormatter.string(from: focusSession.date ?? .now)
        let capitalizedDate = formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()

        dateString = capitalizedDate
    }
    
    func getHourString() {
        let startDate = focusSession.date ?? .now
        
        let endDate = getEndDate(from: startDate, adding: TimeInterval(focusSession.unwrappedTotalTime))

        let startTime = getTimeOfTheDayString(from: startDate)
        let endTime = getTimeOfTheDayString(from: endDate)

        let passedTime = formatTime(from: focusSession.unwrappedTotalTime)
        
        hoursString = startTime + " - " + endTime + " (\(passedTime))"
    }
    
    private func getEndDate(from startDate: Date, adding interval: TimeInterval) -> Date {
        return startDate.addingTimeInterval(interval)
    }

    private func getTimeOfTheDayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }
    
    private func formatTime(from time: Int) -> String {
        let hours = time / 3600
        let minutes = (time / 60) % 60

        if time >= 3600 {
            return "\(hours)h\(minutes)min"
        } else if time >= 60 {
            return "\(minutes)min"
        } else if time > 0 {
            return "\(time)s"
        } else {
            return "\(time)min"
        }
    }
}
