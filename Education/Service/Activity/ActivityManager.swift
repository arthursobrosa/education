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
            if let focusSessionModel, isShowingActivity {
                self.activityDelegate?.setActivityView(focusSessionModel: self.focusSessionModel)
                
                if !focusSessionModel.isPaused {
                    self.startTimer()
                }
                
                self.activityDelegate?.changeActivityVisibility(isShowing: true)
                
                return
            }
            
            self.timer.invalidate()
            self.activityDelegate?.removeActivityView()
        }
    }
    
    var focusSessionModel: FocusSessionModel?
    
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
    
    init(focusSessionManager: FocusSessionManager = FocusSessionManager()) {
        self.focusSessionManager = focusSessionManager
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self,
                  let focusSessionModel else { return }
            
            switch focusSessionModel.timerCase {
                case .stopwatch:
                    focusSessionModel.timerSeconds += 1
                case .timer, .pomodoro:
                    focusSessionModel.timerSeconds -= 1
            }
            
            self.activityDelegate?.updateActivityView(timerSeconds: focusSessionModel.timerSeconds)
            
            if focusSessionModel.timerSeconds <= 0 {
                self.handleTimerEnd()
                return
            }
        }
    }
    
    private func handleTimerEnd() {
        guard let focusSessionModel else { return }
        
        switch focusSessionModel.timerCase {
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
                    
                    focusSessionModel.totalSeconds = self.restTime
                    focusSessionModel.timerSeconds = focusSessionModel.totalSeconds
                } else {
                    self.currentLoop += 1
                    self.isAtWorkTime.toggle()
                    
                    focusSessionModel.totalSeconds = self.workTime
                    focusSessionModel.timerSeconds = focusSessionModel.totalSeconds
                }
        }
    }
    
    func handleActivityDismissed(_ dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let focusSessionViewController = dismissed.children.first as? FocusSessionViewController,
              !focusSessionViewController.viewModel.didTapFinishButton else { return nil }
        
        guard let focusSessionModel else { return nil }
        
        switch focusSessionModel.timerCase {
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                self.workTime = workTime
                self.restTime = restTime
                self.numberOfLoops = numberOfLoops
            default:
                break
        }

        self.focusSessionModel = focusSessionViewController.viewModel.focusSessionModel
        self.date = focusSessionViewController.viewModel.date
        
        self.isShowingActivity = true
        
        return nil
    }
    
    func updateAfterBackground(timeInBackground: Int) {
        guard let focusSessionModel else { return }
        
        switch focusSessionModel.timerCase {
            case .stopwatch:
                if timeInBackground > 0 && !focusSessionModel.isPaused {
                    focusSessionModel.timerSeconds += timeInBackground
                }
            case .timer, .pomodoro:
                if timeInBackground > 0 && !focusSessionModel.isPaused {
                    focusSessionModel.timerSeconds -= timeInBackground
                    
                    if focusSessionModel.timerSeconds <= 0 {
                        focusSessionModel.timerSeconds = 0
                        self.activityDelegate?.changeActivityButtonState()
                    }
                }
        }
        
        self.activityDelegate?.updateActivityView(timerSeconds: focusSessionModel.timerSeconds)
    }
    
    private func saveFocusSesssion() {
        guard let focusSessionModel else { return }
        
        var totalTime: Int = 0
        
        switch focusSessionModel.timerCase {
            case .stopwatch:
                totalTime = focusSessionModel.timerSeconds
            case .timer:
                totalTime = focusSessionModel.totalSeconds - focusSessionModel.timerSeconds
            case .pomodoro:
                if self.isAtWorkTime {
                    totalTime = (self.workTime * self.currentLoop) + (focusSessionModel.totalSeconds - focusSessionModel.timerSeconds)
                } else {
                    totalTime = self.workTime * (self.currentLoop + 1)
                }
        }
        
        self.focusSessionManager.createFocusSession(date: self.date, totalTime: totalTime, subjectID: focusSessionModel.subject?.unwrappedID)
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
