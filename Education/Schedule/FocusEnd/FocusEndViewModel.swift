//
//  FocusEndViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Foundation

class FocusEndViewModel {
    // MARK: - Activity and SubjectManager

    let activityManager: ActivityManager
    private let subjectManager: SubjectManager
    
    // MARK: - Properties
    
    var subjectNames: [String] = []
    var selectedSubjectInfo: (name: String, index: Int) = (String(), 0)
    
    var dateString: String = String()
    var hoursString: String = String()
    var timerModeString: String = String()

    // MARK: - Initializer

    init(activityManager: ActivityManager, subjectManager: SubjectManager = SubjectManager()) {
        self.activityManager = activityManager
        self.subjectManager = subjectManager
        
        setSelectedSubjectInfo()
        getDateString()
        getHourString()
        getTimerModeString()
    }

    // MARK: - Methods
    
    func fetchSubjectNames() {
        subjectNames.append(String(localized: "none"))
        
        if let unwrappedSubjects = subjectManager.fetchSubjects() {
            var unwrappedNames = unwrappedSubjects.map({ $0.unwrappedName })
            unwrappedNames.sort()
            subjectNames.append(contentsOf: unwrappedNames)
        }
    }
    
    private func setSelectedSubjectInfo() {
        guard var subjects = subjectManager.fetchSubjects() else {
            selectedSubjectInfo = (name: String(localized: "none"), index: 0)
            return
        }
        
        guard let activitySubject = activityManager.subject else {
            selectedSubjectInfo = (name: String(localized: "none"), index: 0)
            return
        }
        
        subjects.sort(by: { $0.unwrappedName < $1.unwrappedName })
        
        guard let index = subjects.firstIndex(where: { $0.unwrappedName == activitySubject.unwrappedName }) else {
            return
        }
        
        selectedSubjectInfo = (name: activitySubject.unwrappedName, index: Int(index + 1))
    }
    
    func updateActivityManagerSubject() {
        guard let subjects = subjectManager.fetchSubjects() else {
            activityManager.subject = nil
            return
        }
        
        let index = selectedSubjectInfo.index
        
        guard index > 0 else {
            activityManager.subject = nil
            return
        }
        
        let sortedSubjects = subjects.sorted(by: { $0.unwrappedName < $1.unwrappedName })
        activityManager.subject = sortedSubjects[index - 1]
    }

    private func getDateString() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        let formattedDate = dateFormatter.string(from: activityManager.date)
        let capitalizedDate = formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()

        dateString = capitalizedDate
    }

    private func getHourString() {
        let startDate = activityManager.date
        
        let endDate = getEndDate(from: startDate, adding: TimeInterval(activityManager.totalTime))

        let startTime = getTimeOfTheDayString(from: startDate)
        let endTime = getTimeOfTheDayString(from: endDate)

        let passedTime = formatTime(from: activityManager.totalTime)
        
        hoursString = startTime + " - " + endTime + " (\(passedTime))"
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

    private func getTimerModeString() {
        var text: String
        
        switch activityManager.timerCase {
        case .timer:
            text = String(localized: "timerSelectionBold")
        case .pomodoro:
            text = String(localized: "pomodoroSelectionTitle")
        case .stopwatch:
            text = String(localized: "stopwatchSelectionBold")
        }
        
        timerModeString = text
    }
}
