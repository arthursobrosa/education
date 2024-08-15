//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation

class FocusSessionViewModel {
    // MARK: - FocusSession Handler
    private let focusSessionManager: FocusSessionManager
   
    // MARK: - Properties
    var didTapFinishButton = false
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
        ActivityManager.shared.date = Date.now
    }
    
    // MARK: - Methods
    func getTimerString() -> String {
        var seconds = Int()
        var minutes = Int()
        var hours = Int()
        
        let timerSeconds = ActivityManager.shared.timerSeconds
        
        if timerSeconds > 0 {
            seconds = timerSeconds % 60
            minutes = timerSeconds / 60 % 60
            hours = timerSeconds / 3600
        }
        
        return "\(hours)h \(minutes)m \(seconds)s"
    }
    
    func getStrokeEnd() -> CGFloat {
        let timerSeconds = ActivityManager.shared.timerSeconds
        let totalSeconds = ActivityManager.shared.totalSeconds

        return 1 - (CGFloat(timerSeconds) / CGFloat(totalSeconds))
    }
    
    func pauseResumeButtonTapped() {
        let timerState = ActivityManager.shared.timerState
        
        let newTimerState: ActivityManager.TimerState = timerState == .starting ? .reseting : .starting
        ActivityManager.shared.timerState = newTimerState
    }
    
    func saveFocusSession() {
        ActivityManager.shared.finishSession()
    }
}

enum TimerCase {
    case stopwatch
    case timer
    case pomodoro(workTime: Int, restTime: Int, numberOfLoops: Int)
}
