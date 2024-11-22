//
//  FocusSubjectDetailsViewModel.swift
//  Education
//
//  Created by Leandro Silva on 07/11/24.
//

import Foundation

class FocusSubjectDetailsViewModel {
    // MARK: - Focus Session Manager
    
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Properties
    
    var focusSession: FocusSession
    var currentNotes: String = String()
    
    // MARK: - Initializer
    
    init(focusSession: FocusSession) {
        focusSessionManager = FocusSessionManager()
        self.focusSession = focusSession
    }
    
    // MARK: - Methods
    
    func updateFocusSession() {
        guard currentNotes != focusSession.unwrappedNotes else { return }
        
        focusSession.notes = currentNotes
        focusSessionManager.updateFocusSession(focusSession)
    }
    
    func removeFocusSession() {
        focusSessionManager.deleteFocusSession(focusSession)
    }
    
    func getSubjectName(subjectID: String) -> Subject? {
        let subjectManager = SubjectManager()
        return subjectManager.fetchSubject(withID: subjectID)
    }
    
    func getTitle() -> String {
        let subject = getSubjectName(subjectID: focusSession.unwrappedSubjectID)
        
        if var subjectName = subject?.unwrappedName {
            var formattedSubjectName = subjectName
            
            let maxLength = 25
            if subjectName.count >= maxLength {
                formattedSubjectName = String(subjectName.prefix(25)) + "..."
            }
            
            subjectName = String(format: NSLocalizedString("activityOf", comment: ""), formattedSubjectName)
            return subjectName
        }
        
        return String()
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        let formattedDate = dateFormatter.string(from: focusSession.date ?? .now)
        let capitalizedDate = formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()

        return capitalizedDate
    }
    
    func getHourString() -> String {
        let startDate = focusSession.date ?? .now
        
        let endDate = getEndDate(from: startDate, adding: TimeInterval(focusSession.unwrappedTotalTime))

        let startTime = getTimeOfTheDayString(from: startDate)
        let endTime = getTimeOfTheDayString(from: endDate)

        let passedTime = formatTime(from: focusSession.unwrappedTotalTime)
        
        return startTime + " - " + endTime + " (\(passedTime))"
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
