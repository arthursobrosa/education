//
//  ActivityManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/08/24.
//

import UIKit

class ActivityManager {
    // MARK: - Shared Instance
    static let shared = ActivityManager()
    
    // MARK: - Delegate and FocusSession manager
    weak var activityDelegate: ActivityDelegate?
    private let focusSessionManager: FocusSessionManager
    
    // MARK: - Properties to initialize
    var date: Date
    
    enum TimerState: String {
        case starting = "pause"
        case reseting = "play"
        
        var imageName: String {
            return "\(self.rawValue).fill"
        }
    }
    
    @Published var timerState: TimerState? {
        didSet {
            guard let timerState else { return }
            
            switch timerState {
                case .starting:
                    self.startTimer()
                case .reseting:
                    self.stopTimer()
            }
        }
    }

    var totalSeconds: Int
    
    @Published var timerSeconds: Int {
        didSet {
            if timerSeconds <= 0 {
                self.handleTimerEnd()
            }
        }
    }
    
    var timerCase: TimerCase
    var subject: Subject?
    var blocksApps: Bool
    var isTimeCountOn: Bool
    var isAlarmOn: Bool
    
    var isAtWorkTime: Bool
    var workTime = Int()
    var restTime = Int()
    var numberOfLoops = Int()
    var currentLoop = Int()
    
    var color: UIColor?
    
    // MARK: - Other properties
    var timer = Timer()
    
    var isShowingActivity: Bool = false {
        didSet {
            if isShowingActivity {
                self.activityDelegate?.setActivityView()
                self.activityDelegate?.changeActivityVisibility(isShowing: true)
                
                return
            }
            
            self.activityDelegate?.removeActivityView()
        }
    }
    
    @Published var updateAfterBackground: Bool = false {
        didSet {
            guard updateAfterBackground,
                  self.isShowingActivity else { return }
            
            self.activityDelegate?.updateActivityView()
            self.activityDelegate?.setActivityView()
        }
    }
    
    @Published var showEndAlert: Bool
    
    // MARK: - Initializer
    init(focusSessionManager: FocusSessionManager = FocusSessionManager(), date: Date = Date.now, timerState: TimerState? = nil, totalSeconds: Int = 1, timerSeconds: Int = 1, timerCase: TimerCase = .timer, subject: Subject? = nil, isAtWorkTime: Bool = false, blocksApps: Bool = false, isTimeCountOn: Bool = false, isAlarmOn: Bool = false, showEndAlert: Bool = false, color: UIColor? = nil) {
        self.focusSessionManager = focusSessionManager
        
        self.date = date
        self.timerState = timerState
        self.totalSeconds = totalSeconds
        self.timerSeconds = timerSeconds
        self.timerCase = timerCase
        self.subject = subject
        self.isAtWorkTime = isAtWorkTime
        self.blocksApps = blocksApps
        self.isTimeCountOn = isTimeCountOn
        self.isAlarmOn = isAlarmOn
        self.showEndAlert = showEndAlert
        self.color = color
        
        switch self.timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.workTime = workTime
                self.restTime = restTime
                self.numberOfLoops = numberOfLoops
            default:
                break
        }
    }
    
    // MARK: - Methods
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            switch self.timerCase {
                case .stopwatch:
                    self.timerSeconds += 1
                case .timer, .pomodoro:
                    self.timerSeconds -= 1
            }
            
            guard self.isShowingActivity else { return }
            
            self.activityDelegate?.updateActivityView()
        }
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    func handleTimerEnd() {
        switch self.timerCase {
            case .stopwatch:
                return
            case .timer:
                self.activityDelegate?.changeActivityButtonState()
                self.stopTimer()
                self.showEndAlert = true
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                if self.isAtWorkTime {
                    if self.currentLoop >= numberOfLoops - 1 {
                        self.activityDelegate?.changeActivityButtonState()
                        self.stopTimer()
                        self.showEndAlert = true
                        return
                    }
                    
                    self.isAtWorkTime.toggle()
                    
                    self.totalSeconds = restTime
                    self.timerSeconds = self.totalSeconds
                } else {
                    self.currentLoop += 1
                    self.isAtWorkTime.toggle()
                    
                    self.totalSeconds = workTime
                    self.timerSeconds = self.totalSeconds
                }
                
                self.activityDelegate?.updateActivityView()
                self.activityDelegate?.setActivityView()
                
                self.timerState = .reseting
                self.timerState = .starting
        }
    }
    
    func handleActivityDismissed(didTapFinish: Bool) {
        guard !didTapFinish else { return }
        
        self.isShowingActivity = true
    }
    
    func saveFocusSesssion() {
        self.timerState = .reseting
        
        var totalTime: Int = 0
        
        switch self.timerCase {
            case .stopwatch:
                totalTime = self.timerSeconds
            case .timer:
                totalTime = self.totalSeconds - self.timerSeconds
            case .pomodoro(let workTime, _, _):
                if self.isAtWorkTime {
                    totalTime = (workTime * self.currentLoop) + (self.totalSeconds - self.timerSeconds)
                } else {
                    totalTime = workTime * (self.currentLoop + 1)
                }
        }
        
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: totalTime, subjectID: self.subject?.unwrappedID)
    }
    
    func finishSession() {
        guard self.isShowingActivity else { return }
        
        self.saveFocusSesssion()
        self.isShowingActivity = false
    }
    
    func changeActivityVisibility(isShowing: Bool) {
        guard self.isShowingActivity else { return }
        
        self.activityDelegate?.changeActivityVisibility(isShowing: isShowing)
    }
    
    func updateFocusSession(with focusSessionModel: FocusSessionModel) {
        self.timerState = focusSessionModel.timerState
        self.totalSeconds = focusSessionModel.totalSeconds
        self.timerSeconds = focusSessionModel.timerSeconds
        self.timerCase = focusSessionModel.timerCase
        self.subject = focusSessionModel.subject
        self.isAtWorkTime = focusSessionModel.isAtWorkTime
        self.currentLoop = focusSessionModel.currentLoop
        self.blocksApps = focusSessionModel.blocksApps
        self.isTimeCountOn = focusSessionModel.isTimeCountOn
        self.isAlarmOn = focusSessionModel.isAlarmOn
        self.showEndAlert = focusSessionModel.showEndAlert
        self.color = focusSessionModel.color
    }
    
    func updateAfterBackground(timeInBackground: Int) {
        self.updateAfterBackground = self.handleAfterBackground(timeInBackground)
    }
    
    func handleAfterBackground(_ timeInBackground: Int) -> Bool {
        guard timeInBackground > 0,
              self.timerState == .starting else { return false }
        
        switch self.timerCase {
            case .timer:
                self.timerSeconds -= timeInBackground
            case .stopwatch:
                self.timerSeconds += timeInBackground
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.handlePomodoro(timeInBackground, workTime: workTime, restTime: restTime, numberOfLoops: numberOfLoops)
        }
        
        return true
    }
    
    private func handlePomodoro(_ timeInBackground: Int, workTime: Int, restTime: Int, numberOfLoops: Int) {
        var loopStartTime = self.currentLoop * (workTime + restTime)
        var loopPassedTime = self.isAtWorkTime ? (workTime - self.timerSeconds) : (workTime + (restTime - self.timerSeconds))
        let totalPassedTime = loopStartTime + loopPassedTime + timeInBackground
        
        self.currentLoop = totalPassedTime / (workTime + restTime)
        loopStartTime = self.currentLoop * (workTime + restTime)
        loopPassedTime = totalPassedTime - loopStartTime
        self.isAtWorkTime = loopPassedTime < workTime
        
        if self.currentLoop >= numberOfLoops - 1 && !self.isAtWorkTime {
            self.isAtWorkTime = true
            self.timerSeconds = 0
            
            return
        }
        
        self.timerSeconds = self.isAtWorkTime ? (workTime - loopPassedTime) : (restTime - (loopPassedTime - workTime))
    }
}
