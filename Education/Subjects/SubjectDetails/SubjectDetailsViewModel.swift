//
//  SubjectDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import Foundation

class SubjectDetailsViewModel {
    // MARK: - Subject and FocusSession Managers
    
    private let subjectManager: SubjectManager
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Properties
    
    let studyTimeViewModel: StudyTimeViewModel

    var subject: Subject?
    var sessionsByMonth: [String: [FocusSession]] = [:]
    
    var wasSubjectDeleted: Bool = false

    // MARK: - Initializer
    
    init(subjectManager: SubjectManager = SubjectManager(), focusSessionManager: FocusSessionManager = FocusSessionManager(), subject: Subject?, studyTimeViewModel: StudyTimeViewModel) {
        self.subjectManager = subjectManager
        self.focusSessionManager = focusSessionManager

        self.subject = subject
        self.studyTimeViewModel = studyTimeViewModel
    }
    
    // MARK: - Methods
    
    func fetchFocusSessions() {
        var sessionsByMonth: [String: [FocusSession]] = [:]

        if let focusSessions = focusSessionManager.fetchFocusSessions(subjectID: subject?.unwrappedID) {
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

        self.sessionsByMonth = sessionsByMonth
    }
    
    func updateSubject() {
        if let newSubject = subjectManager.fetchSubject(withID: subject?.unwrappedID) {
            subject = newSubject
        } else {
            wasSubjectDeleted = true
        }
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
    
    func formattedMonthYear(_ monthYear: String) -> String? {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        guard let date = dateFormatter.date(from: monthYear) else {
            return nil
        }
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMyyyy")

        let formattedDate = dateFormatter.string(from: date)
        return formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()
    }
}
