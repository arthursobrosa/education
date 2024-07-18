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
    
    func getTotalTime(forSubject subject: Subject?) -> Int {
        let focusSessions = self.focusSessions.value.filter { $0.subjectID == subject?.unwrappedID }
        
        return self.getTime(from: focusSessions)
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
        
        let times = subjectTotals.map { SubjectTime(subject: $0.key, totalTime: $0.value) }
        
        for time in times {
            self.aggregatedTimes.append(SubjectTime(
                subject: idToName(subjectId: time.subject),
                totalTime: time.totalTime))
        }
    }
    
    private func idToName(subjectId: String) -> String {
        let subject = self.subjectManager.fetchSubject(withID: subjectId)
        return subject?.unwrappedName ?? String(localized: "studyTimeOther")
    }
}
