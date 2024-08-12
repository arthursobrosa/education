//
//  ActivityManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityManager {
    static let shared = ActivityManager()
    
    weak var activityDelegate: ActivityDelegate?
    private let focusSessionManager: FocusSessionManager
    
    var timer = Timer()
    
    var isShowingActivity: Bool = false {
        didSet {
            if isShowingActivity {
                self.activityDelegate?.setActivityView(color: self.color, 
                                                       subject: self.subject, 
                                                       totalSeconds: self.totalSeconds,
                                                       timerSeconds: self.timerSeconds,
                                                       isPaused: self.isPaused)
                
                if !isPaused {
                    self.startTimer()
                }
                
                self.activityDelegate?.changeActivityVisibility(isShowing: true)
                
                return
            }
            
            self.timer.invalidate()
            self.activityDelegate?.removeActivityView()
        }
    }
    
    var color: UIColor?
    var subject: Subject?
    var totalSeconds = Int()
    var timerSeconds = Int() {
        didSet {
            self.activityDelegate?.updateActivityView(timerSeconds: timerSeconds)
        }
    }
    var timerCase: TimerCase = .timer
    var isPaused: Bool = false
    var isAtWorkTime: Bool = false {
        didSet {
            self.activityDelegate?.changeActivityIsAtWorkTime(isAtWorkTime)
        }
    }
    var workTime = Int()
    var restTime = Int()
    var numberOfLoops = Int()
    var currentLoop = 0
    
    var date = Date()
    
    var blocksApps: Bool = false
    var isTimeCountOn: Bool = true
    var isAlarmOn: Bool = false
    
    init(focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            
            switch self.timerCase {
                case .stopwatch:
                    self.timerSeconds += 1
                case .timer, .pomodoro:
                    self.timerSeconds -= 1
            }
            
            if self.timerSeconds <= 0 {
                self.handleTimerEnd()
                return
            }
        }
    }
    
    private func handleTimerEnd() {
        switch self.timerCase {
            case .stopwatch:
                return
            case .timer:
                self.activityDelegate?.changeActivityButtonState()
                self.timer.invalidate()
            case .pomodoro:
                if self.isAtWorkTime {
                    if self.currentLoop >= self.numberOfLoops - 1 {
                        self.activityDelegate?.changeActivityButtonState()
                        self.timer.invalidate()
                        return
                    }
                    
                    self.isAtWorkTime.toggle()
                    
                    self.totalSeconds = self.restTime
                    self.timerSeconds = self.totalSeconds
                } else {
                    self.currentLoop += 1
                    self.isAtWorkTime.toggle()
                    
                    self.totalSeconds = self.workTime
                    self.timerSeconds = self.totalSeconds
                }
        }
    }
    
    func handleActivityDismissed(_ dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let focusSessionViewController = dismissed.children.first as? FocusSessionViewController,
              !focusSessionViewController.viewModel.didTapFinishButton else { return nil }
        
        let timerCase = focusSessionViewController.viewModel.timerCase
        self.timerCase = timerCase
        
        switch timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.workTime = workTime
                self.restTime = restTime
                self.numberOfLoops = numberOfLoops
            default:
                break
        }

        self.color = focusSessionViewController.color
        self.subject = focusSessionViewController.viewModel.subject
        self.totalSeconds = focusSessionViewController.viewModel.totalSeconds
        self.timerSeconds = focusSessionViewController.viewModel.timerSeconds.value
        self.isPaused = focusSessionViewController.viewModel.timerState.value == .reseting
        self.isAtWorkTime = focusSessionViewController.viewModel.isAtWorkTime
        self.currentLoop = focusSessionViewController.viewModel.currentLoop
        self.date = focusSessionViewController.viewModel.date
        self.blocksApps = focusSessionViewController.viewModel.blocksApps
        self.isTimeCountOn = focusSessionViewController.viewModel.isVisible
        self.isAlarmOn = focusSessionViewController.viewModel.isAlarmOn
        
        self.isShowingActivity = true
        
        return nil
    }
    
    func updateAfterBackground(timeInBackground: Int) {
        switch self.timerCase {
            case .stopwatch:
                if timeInBackground > 0 && !self.isPaused {
                    self.timerSeconds += timeInBackground
                }
            case .timer, .pomodoro:
                if timeInBackground > 0 && !self.isPaused {
                    self.timerSeconds -= timeInBackground
                    
                    if self.timerSeconds <= 0 {
                        self.timerSeconds = 0
                        self.activityDelegate?.changeActivityButtonState()
                    }
                }
        }
    }
    
    private func saveFocusSesssion() {
        var totalTime: Int = 0
        
        switch self.timerCase {
            case .stopwatch:
                totalTime = self.timerSeconds
            case .timer:
                totalTime = self.totalSeconds - self.timerSeconds
            case .pomodoro:
                if self.isAtWorkTime {
                    totalTime = (self.workTime * self.currentLoop) + (self.totalSeconds - self.timerSeconds)
                } else {
                    totalTime = self.workTime * (self.currentLoop + 1)
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
}
