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
    
    var timer = Timer()
    
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
    
    let date: Date
    
    var focusSessionModel: FocusSessionModel
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager(), focusSessionModel: FocusSessionModel) {
        self.focusSessionManager = focusSessionManager
        
        self.focusSessionModel = focusSessionModel
        
        self.timerState = Box(nil)
        self.date = Date.now
        
        self.totalSeconds = focusSessionModel.totalSeconds
        self.timerSeconds = Box(focusSessionModel.timerSeconds)
    }
    
    // MARK: - Methods
    func startFocusSession() {
        self.timerState.value = .starting
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            switch self.focusSessionModel.timerCase {
                case .stopwatch:
                    self.timerSeconds.value += 1
                case .timer, .pomodoro:
                    self.timerSeconds.value -= 1
            }
            
            self.focusSessionModel.timerSeconds = self.timerSeconds.value
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
        var totalTime: Int = 0
        
        switch self.focusSessionModel.timerCase {
            case .stopwatch:
                totalTime = self.timerSeconds.value
            case .timer:
                totalTime = self.totalSeconds - self.timerSeconds.value
            case .pomodoro(let workTime, _, _):
                if self.focusSessionModel.isAtWorkTime {
                    totalTime = (workTime * self.focusSessionModel.currentLoop) + (self.focusSessionModel.totalSeconds - self.timerSeconds.value)
                } else {
                    totalTime = workTime * (self.focusSessionModel.currentLoop + 1)
                }
        }
        
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: totalTime, subjectID: focusSessionModel.subject?.unwrappedID)
    }
}

enum TimerCase {
    case stopwatch
    case timer
    case pomodoro(workTime: Int, restTime: Int, numberOfLoops: Int)
}
