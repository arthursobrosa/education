//
//  StudyTimeViewModel.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit
import Foundation

enum DateRange: Int {
    case lastWeek
    case lastMonth
    case lastYear
}

struct SubjectTime : Identifiable{
    var id = UUID()
    var subject: String
    let totalTime: Int
}

class StudyTimeViewModel : ObservableObject {
    private let subjectManager: SubjectManager
    private let focusSessionManager: FocusSessionManager
    
    
    @Published var selectedDateRange: DateRange = .lastWeek {
        didSet {
            fetchFocusSessions()
        }
    }
    @Published var aggregatedTimes: [SubjectTime] = []
    
    init(subjectmanager: SubjectManager = SubjectManager(), focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.subjectManager = subjectmanager
        self.focusSessionManager = focusSessionManager
    }
    
    var subjects = Box([Subject]())
    var focusSessions = Box([FocusSession]())
    
    func fetchFocusSessions() {
        if let focusSessions = self.focusSessionManager.fetchFocusSessions(allSessions: true) {
            
            let calendar = Calendar.current
            let now = Date()
            var startDate: Date
            
            switch selectedDateRange {
            case .lastWeek:
                startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            case .lastMonth:
                startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            case .lastYear:
                startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            }
            
            let filteredSessions = focusSessions.filter { $0.date! >= startDate }
            
            
            self.focusSessions.value = filteredSessions
        }
    }
    
    
    func getTotalTimeOneSubject(_ subject: Subject?) -> Int {
        
        var totalTime: Int = 0
        
        for session in focusSessions.value {
            if session.unwrappedSubjectID == subject?.unwrappedID{
                totalTime += session.unwrappedTotalTime
            }
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
    
    func aggregateTimes() {
        aggregatedTimes = []
        
        
        var subjectTotals: [String: Int] = [:]
        
        for session in focusSessions.value {
            subjectTotals[session.unwrappedSubjectID, default: 0] += session.unwrappedTotalTime
        }
        
        let times = subjectTotals.map { SubjectTime(subject: $0.key, totalTime: $0.value) }
        
        
        for total in times {
            aggregatedTimes.append(SubjectTime(subject: idToName(subjectId: total.subject)
                                               , totalTime: total.totalTime))
            
        }
        
    }
    
    func idToName(subjectId: String) -> String{
        let subject = self.subjectManager.fetchSubject(withID: subjectId)
        return subject?.unwrappedName ?? "Teste"
    }
}
