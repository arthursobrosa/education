//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation

class FocusSessionViewModel {
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Properties
    var countdownTimer = Timer()
    
    var totalSeconds: Int {
        didSet {
            self.timerSeconds.value = totalSeconds
        }
    }
    
    var timerSeconds: Box<Int>
    
    enum TimerState: String {
        case starting = "pause"
        case reseting = "play"
        
        var imageName: String {
            return "\(self.rawValue).fill"
        }
    }
    
    var timerState: Box<TimerState?>
    
    private let subjectID: String?
    private let date: Date
    
    // MARK: - Initializer
    init(totalSeconds: Int, subjectID: String?, focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
        
        self.totalSeconds = totalSeconds
        self.timerSeconds = Box(totalSeconds)
        self.timerState = Box(nil)
        self.subjectID = subjectID
        self.date = Date.now
    }
    
    // MARK: - Methods
    func startFocusSession() {
        self.timerState.value = .starting
    }
    
    func startCountownTimer() {
        self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerSeconds.value -= 1
        }
    }
    
    func getTimerString() -> String {
        var seconds = Int()
        var minutes = Int()
        var hours = Int()
        
        if self.timerSeconds.value > 0 {
            seconds = self.timerSeconds.value % 60
            minutes = self.timerSeconds.value / 60 % 60
            hours = self.timerSeconds.value / 3600
        }
        
        return "\(hours)h \(minutes)m \(seconds)s"
    }
    
    func getStrokeEnd() -> CGFloat {
        return 1 - (CGFloat(self.timerSeconds.value) / CGFloat(self.totalSeconds))
    }
    
    func pauseResumeButtonTapped() {
        let newTimerState: TimerState = self.timerState.value == .starting ? .reseting : .starting
        self.timerState.value = newTimerState
    }
    
    func saveFocusSession() {
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: (self.totalSeconds - self.timerSeconds.value), subjectID: self.subjectID)
    }
}
