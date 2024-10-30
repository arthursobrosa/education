//
//  FocusEndViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Foundation

class FocusEndViewModel {
    // MARK: - Service to manage timer and session

    let activityManager: ActivityManager

    // MARK: - Initializer

    init(activityManager: ActivityManager) {
        self.activityManager = activityManager
    }

    // MARK: - Methods

    func getSubjectString() -> String {
        if let subject = activityManager.subject {
            return subject.unwrappedName
        }

        return String(localized: "none")
    }

    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        let formattedDate = dateFormatter.string(from: activityManager.date)
        let capitalizedDate = formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()

        return capitalizedDate
    }

    func getHourString() -> String {
        let startDate = activityManager.date
        let endDate = Date.now

        let startTime = getTimeOfTheDayString(from: startDate)
        let endTime = getTimeOfTheDayString(from: endDate)

        let passedTime = getDifferenceBetween(startDate, and: endDate)

        return startTime + " - " + endTime + " (\(passedTime))"
    }

    private func getTimeOfTheDayString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: date)
    }

    private func getDifferenceBetween(_ date1: Date, and date2: Date) -> String {
        let differenceInSeconds = date2.timeIntervalSince(date1)
        return formatTime(from: Int(differenceInSeconds))
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

    func getTimerString() -> String {
        switch activityManager.timerCase {
        case .timer:
            String(localized: "timerSelectionBold")
        case .pomodoro:
            String(localized: "pomodoroSelectionTitle")
        case .stopwatch:
            String(localized: "stopwatchSelectionBold")
        }
    }
}
