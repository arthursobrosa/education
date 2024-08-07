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
    var isVisible = true
    
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
    
    let subject: Subject?
    private let date: Date
    
    var workTime = 0
    var restTime = 0
    var numberOfLoops = 0
    var currentLoop = 0
    var isAtWorkTime = true
    
    var timerCase: TimerCase
    
    // MARK: - Initializer
    init(totalSeconds: Int, subject: Subject?, timerCase: TimerCase, focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
        
        self.timerState = Box(nil)
        self.subject = subject
        self.date = Date.now
        
        self.totalSeconds = totalSeconds
        self.timerSeconds = Box(totalSeconds)
        self.timerCase = timerCase
        
        switch timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.workTime = workTime
                self.restTime = restTime
                self.numberOfLoops = numberOfLoops
            default:
                break
        }
    }
    
    // MARK: - Methods
    func startFocusSession() {
        self.timerState.value = .starting
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            switch self.timerCase {
                case .stopwatch:
                    self.timerSeconds.value += 1
                case .timer, .pomodoro:
                    self.timerSeconds.value -= 1
            }
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
        
        switch self.timerCase {
            case .stopwatch:
                totalTime = self.timerSeconds.value
            case .timer:
                totalTime = self.totalSeconds - self.timerSeconds.value
            case .pomodoro:
                if self.isAtWorkTime {
                    totalTime = (self.workTime * self.currentLoop) + (self.totalSeconds - self.timerSeconds.value)
                } else {
                    totalTime = self.workTime * (self.currentLoop + 1)
                }
        }
        
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: totalTime, subjectID: self.subject?.unwrappedID)
    }
}
