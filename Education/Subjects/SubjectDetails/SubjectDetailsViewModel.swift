//
//  SubjectDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation

class SubjectDetailsViewModel {
    private let focusSessionManager: FocusSessionManager
    let subjectManager: SubjectManager
    let studyTimeViewModel: StudyTimeViewModel

    var subject: Subject?
    var sessionsByMonth: [String: [FocusSession]] = [:]

    init(subject: Subject?, studyTimeViewModel: StudyTimeViewModel) {
        self.subject = subject
        self.studyTimeViewModel = studyTimeViewModel
       
        focusSessionManager = FocusSessionManager()
        subjectManager = SubjectManager()
    }
    
    func fetchFocusSessions() {
        var sessionsByMonth: [String: [FocusSession]] = [:]

        if let focusSessions = focusSessionManager.fetchFocusSessions(subjectID: self.subject?.unwrappedID) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yyyy"
            
            for session in focusSessions {
                if let date = session.date {
                    let monthKey = dateFormatter.string(from: date)
                    sessionsByMonth[monthKey, default: []].append(session)
                }
            }
            
            // Ordena as sessões de cada mês em ordem decrescente de data
            for (month, sessions) in sessionsByMonth {
                sessionsByMonth[month] = sessions.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
            }
        }
        
        
        
        print(sessionsByMonth)
        
        self.sessionsByMonth = sessionsByMonth
    }
    
    func areSessionsEmpty() -> Bool {
        guard let focusSessions = focusSessionManager.fetchFocusSessions(subjectID: subject?.unwrappedID) else {
            return true
        }
        
        return focusSessions.isEmpty
    }
    
    func deleteOtherSessions() {
        if let focusSessions = focusSessionManager.fetchFocusSessions(subjectID: nil) {
            for focusSession in focusSessions {
                focusSessionManager.deleteFocusSession(focusSession)
            }
        }
    }


}
