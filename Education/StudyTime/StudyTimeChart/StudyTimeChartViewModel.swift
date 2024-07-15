//
//  StudyTimeChartViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 15/07/24.
//

import Foundation


enum DateRange: Int {
    case lastWeek
    case lastMonth
    case lastYear
}

struct Focus {
    let subject: String
    let date: Date
    let totalTime: Int
}

struct SubjectTime: Identifiable {
    let id = UUID()
    let subject: String
    let totalTime: Int
}

class StudyTimeChartViewModel: ObservableObject {
    @Published var sessions: [Focus] = []
    @Published var selectedDateRange: DateRange = .lastWeek
    @Published var aggregatedTimes: [SubjectTime] = []

    init() {
        self.sessions = [
            Focus(subject: "Math", date: Date(), totalTime: 3600),
            Focus(subject: "Science", date: Date(), totalTime: 5400),
            Focus(subject: "Math", date: Date(), totalTime: 1800),
            Focus(subject: "Geography", date: Date(), totalTime: 5400),
            Focus(subject: "Law", date: Date(), totalTime: 1800),
            Focus(subject: "History", date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, totalTime: 5400),
            Focus(subject: "Physics", date: Calendar.current.date(byAdding: .month, value: -7, to: Date())!, totalTime: 5400),
            Focus(subject: "Chemistry", date: Date(), totalTime: 1800),

        ]
        
    }

    func aggregateTimes() {
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

            let filteredSessions = sessions.filter { $0.date >= startDate }
            
            var subjectTotals: [String: Int] = [:]

            for session in filteredSessions {
                subjectTotals[session.subject, default: 0] += session.totalTime
            }

            aggregatedTimes = subjectTotals.map { SubjectTime(subject: $0.key, totalTime: $0.value) }
            
            print(aggregatedTimes)
        }
}

