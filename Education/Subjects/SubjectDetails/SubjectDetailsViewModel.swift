//
//  SubjectDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation

class SubjectDetailsViewModel {
    private let focusSessionManager: FocusSessionManager

    let subject: Subject
    var sessionsByMonth: [String: [FocusSession]] = [:]

    init(subject: Subject) {
        self.subject = subject
       
        focusSessionManager = FocusSessionManager()
    }
    
    func fetchFocusSessions() {
        var sessionsByMonth: [String: [FocusSession]] = [:]

        if let focusSessions = focusSessionManager.fetchFocusSessions(subjectID: self.subject.unwrappedID) {
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
        
        
        
        //print(sessionsByMonth)
        
        self.sessionsByMonth = sessionsByMonth
    }


}
