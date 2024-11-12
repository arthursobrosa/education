//
//  FocusSession+Extension.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import Foundation

extension FocusSession {
    var unwrappedID: String {
        id ?? String()
    }

    var unwrappedTotalTime: Int {
        Int(totalTime)
    }

    var unwrappedSubjectID: String {
        subjectID ?? String()
    }
    
    var unwrappedTimerCase: TimerCase {
        switch timerCase {
        case 0:
            .timer
        case 1:
            .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
        case 2:
            .stopwatch
        default:
            .stopwatch
        }
    }
    
    var unwrappedNotes: String {
        notes ?? String()
    }
}
