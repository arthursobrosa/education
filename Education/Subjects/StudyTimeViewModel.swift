//
//  StudyTimeViewModel.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import Foundation

enum DateRange: String, CaseIterable {
    case lastWeek
    case lastMonth
    case lastYear
    
    var name: String {
        switch self {
            case .lastWeek:
                return String(localized: "studyTimeLastWeek")
            case .lastMonth:
                return String(localized: "studyTimeLastMonth")
            case .lastYear:
                return String(localized: "studyTimeLastYear")
        }
    }
}

struct SubjectTime: Identifiable {
    var id = UUID()
    var subject: String
    let totalTime: Int
    let subjectColor: String
    
}

class StudyTimeViewModel : ObservableObject {
    // MARK: - Subject and FocusSession Handlers
    private let subjectManager: SubjectManager
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Properties
    var dateRanges: [DateRange] = DateRange.allCases
    @Published var selectedDateRange: DateRange = .lastWeek {
        didSet {
            self.fetchFocusSessions()
        }
    }
    @Published var aggregatedTimes: [SubjectTime] = []
    
    var subjects = Box([Subject]())
    var focusSessions = Box([FocusSession]())
    
    // MARK: - Initializer
    init(subjectManager: SubjectManager = SubjectManager(), focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.subjectManager = subjectManager
        self.focusSessionManager = focusSessionManager
    }
    
    // MARK: - Methods
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
    
    func getTotalTime(forSubject subject: Subject?) -> String {
        let focusSessions = self.focusSessions.value.filter { $0.subjectID == subject?.unwrappedID }
        let totalTime = self.getTime(from: focusSessions)
        
        let hours = totalTime / 3600
        let minutes = (totalTime / 60) % 60
        
        if totalTime >= 3600 {
            return "\(hours)h\(minutes)m"
        } else if totalTime >= 60 {
            return "\(minutes)m"
        } else {
            return "\(totalTime)s"
        }
    }
    
    func getTotalAggregatedTime() -> String {
        let totalTime = self.getTime(from: focusSessions.value)
        
        let hours = totalTime / 3600
        let minutes = (totalTime / 60) % 60
        
        if totalTime >= 3600 {
            return "\(hours)h\(minutes)m"
        } else if totalTime >= 60 {
            return "\(minutes)m"
        } else {
            return "\(totalTime)s"
        }
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
    
    func updateAggregatedTimes() {
            self.aggregatedTimes = []
            
            var subjectTotals: [String: Int] = [:]
            
            for session in self.focusSessions.value {
                subjectTotals[session.unwrappedSubjectID, default: 0] += session.unwrappedTotalTime
            }
            
            var subjectColors: [String: String] = [:]
            for subjectId in subjectTotals.keys {
                if let subject = self.subjectManager.fetchSubject(withID: subjectId) {
                    subjectColors[subjectId] = subject.unwrappedColor
                }
            }
            
            let times = subjectTotals.map {
                SubjectTime(subject: idToName(subjectId: $0.key), totalTime: $0.value, subjectColor: subjectColors[$0.key] ?? "")
            }
            
            self.aggregatedTimes = times
        }
    
    private func idToName(subjectId: String) -> String {
        let subject = self.subjectManager.fetchSubject(withID: subjectId)
        return subject?.unwrappedName ?? String(localized: "other")
    }
    
    func createSubject(name: String, color: String) {
        subjectManager.createSubject(name: name, color: color)
    }
    
    func removeSubject(subject: Subject){
        self.subjectManager.deleteSubject(subject)
        self.fetchSubjects()
    }
}
