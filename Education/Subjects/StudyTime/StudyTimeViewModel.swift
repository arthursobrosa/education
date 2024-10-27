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

    var calendarComponent: Calendar.Component {
        switch self {
        case .lastWeek:
            return .weekOfYear
        case .lastMonth:
            return .month
        case .lastYear:
            return .year
        }
    }

    func getStartDate() -> Date {
        let calendar = Calendar.current

        return calendar.date(byAdding: calendarComponent, value: -1, to: Date.now) ?? Date.now
    }
}

struct SubjectTime: Identifiable {
    var id = UUID()
    var subject: String
    let totalTime: Int
    let subjectColor: String
}

class StudyTimeViewModel: ObservableObject {
    // MARK: - Subject and FocusSession Handlers

    private let subjectManager: SubjectManager
    private let focusSessionManager: FocusSessionManager

    // MARK: - Properties

    var dateRanges: [DateRange] = DateRange.allCases
    @Published var selectedDateRange: DateRange = .lastWeek {
        didSet {
            fetchFocusSessions()
        }
    }

    @Published var aggregatedTimes: [SubjectTime] = []

    var subjects = Box([Subject]())
    var focusSessions = Box([FocusSession]())

    private let filterSession = { (session: FocusSession, dateRange: DateRange) -> Bool in
        let startDate = dateRange.getStartDate()
        
        guard let sessionDate = session.date,
              sessionDate >= startDate else { return false }
        
        return true
    }

    let subjectColors = ["bluePicker", "blueSkyPicker", "olivePicker", "orangePicker", "pinkPicker", "redPicker", "turquoisePicker", "violetPicker", "yellowPicker"]

    lazy var selectedSubjectColor: Box<String> = Box(self.subjectColors[0])
    var currentEditingSubject: Subject?

    // MARK: - Initializer

    init(subjectManager: SubjectManager = SubjectManager(), focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.subjectManager = subjectManager
        self.focusSessionManager = focusSessionManager

        selectedSubjectColor = Box(selectAvailableColor())
    }

    // MARK: - Methods

    func fetchFocusSessions() {
        if let focusSessions = focusSessionManager.fetchFocusSessions(allSessions: true) {
            self.focusSessions.value = focusSessions.filter { filterSession($0, self.selectedDateRange) }
        }
    }

    func selectAvailableColor() -> String {
        // Obter os subjects existentes
        let existingSubjects = subjectManager.fetchSubjects() ?? []

        // Extrair as cores dos subjects já existentes
        let usedColors = Set(existingSubjects.map { $0.unwrappedColor })

        // Verificar qual cor ainda não foi usada
        for color in subjectColors where !usedColors.contains(color) {
            return color
        }

        // Se todas já foram usadas, retornar a primeira cor
        return subjectColors.first ?? "bluePicker"
    }

    func getTotalTime(forSubject subject: Subject?) -> String {
        let focusSessions = focusSessions.value.filter { $0.subjectID == subject?.unwrappedID }
        let totalTime = getTime(from: focusSessions)
        return formatTime(from: totalTime)
    }

    func getTotalAggregatedTime() -> String {
        let totalTime = getTime(from: focusSessions.value)
        return formatTime(from: totalTime)
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

    private func getTime(from focusSessions: [FocusSession]) -> Int {
        var totalTime = 0

        for focusSession in focusSessions {
            totalTime += focusSession.unwrappedTotalTime
        }

        return totalTime
    }

    func fetchSubjects() {
        if let subjects = subjectManager.fetchSubjects() {
            self.subjects.value = subjects
        }
    }

    func updateAggregatedTimes() {
        aggregatedTimes = []

        var subjectTotals: [String: Int] = [:]

        for session in focusSessions.value {
            subjectTotals[session.unwrappedSubjectID, default: 0] += session.unwrappedTotalTime
        }

        var subjectColors: [String: String] = [:]
        for subjectId in subjectTotals.keys {
            if let subject = subjectManager.fetchSubject(withID: subjectId) {
                subjectColors[subjectId] = subject.unwrappedColor
            }
        }

        let times = subjectTotals.map {
            SubjectTime(subject: idToName(subjectId: $0.key), totalTime: $0.value, subjectColor: subjectColors[$0.key] ?? "button-normal")
        }

        aggregatedTimes = times
    }

    private func idToName(subjectId: String) -> String {
        let subject = subjectManager.fetchSubject(withID: subjectId)
        return subject?.unwrappedName ?? String(localized: "other")
    }

    func createSubject(name: String, color: String) {
        subjectManager.createSubject(name: name, color: color)
    }

    func updateSubject(name: String, color: String) {
        guard let currentEditingSubject else { return }

        if let subject = subjectManager.fetchSubject(withID: currentEditingSubject.unwrappedID) {
            subject.name = name
            subject.color = color

            subjectManager.updateSubject(subject)
        }
    }

    func removeSubject(subject: Subject?) {
        if let subject {
            subjectManager.deleteSubject(subject)
        } else {
            let noSubjectSessions = focusSessions.value.filter { $0.subjectID == subject?.id }
            for focusSession in noSubjectSessions {
                focusSessionManager.deleteFocusSession(focusSession)
            }
        }

        fetchSubjects()
        fetchFocusSessions()
        updateAggregatedTimes()
    }
}
