//
//  StudyTimeViewModel.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeViewModel {
    private let subjectManager: SubjectManager
    private let focusSessionManager: FocusSessionManager
    
    init(subjectmanager: SubjectManager = SubjectManager(), focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.subjectManager = subjectmanager
        self.focusSessionManager = focusSessionManager
    }
    
    var subjects = Box([Subject]())
    var focusSessions = [FocusSession]()
    
    func fetchFocusSessions() {
        if let focusSessions = self.focusSessionManager.fetchFocusSessions(allSessions: true) {
            self.focusSessions = focusSessions
        }
    }
    
    func getTotalTimeAllFocusSession() -> Int {
        return self.getTime(from: self.focusSessions)
    }
    
    func getTotalTimeOneSubject(_ subject: Subject) -> Int {
        if let focusSessions = self.focusSessionManager.fetchFocusSessions(subjectID: subject.unwrappedID) {
            return self.getTime(from: focusSessions)
        }
        
        return 0
    }
    
    private func getTime(from focusSessions: [FocusSession]) -> Int {
        var totalTime: Int = 0
        
        focusSessions.forEach { focusSession in
            totalTime += focusSession.unwrappedTotalTime
        }
        
        return totalTime
    }
    
    func fetchSubjects() {
        if let subjects = self.subjectManager.fetchSubjects() {
            self.subjects.value = subjects
        }
    }
    
    func removeSubject(subject: Subject) {
        self.subjectManager.deleteSubject(subject)
        self.fetchSubjects()
    }
}
