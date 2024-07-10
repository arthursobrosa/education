//
//  FocusSessionViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 26/06/24.
//

import Foundation

class FocusSessionViewModel {
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
    
    // MARK: - Initializer
    init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
        self.timerSeconds = Box(totalSeconds)
        self.timerState = Box(nil)
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
        let seconds = self.timerSeconds.value % 60
        let minutes = self.timerSeconds.value / 60 % 60
        let hours = self.timerSeconds.value / 3600
        
        return "\(hours)h \(minutes)m \(seconds)s"
    }
    
    @objc func pauseResumeButtonTapped() {
        let newTimerState: TimerState = self.timerState.value == .starting ? .reseting : .starting
        self.timerState.value = newTimerState
    }
}
