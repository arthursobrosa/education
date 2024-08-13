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
            if let focusSessionModel,
               let timerState = focusSessionModel.timerState,
               isShowingActivity {
                self.activityDelegate?.setActivityView(focusSessionModel: focusSessionModel)
                
                if timerState == .starting {
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
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                if focusSessionModel.isAtWorkTime {
                    if focusSessionModel.currentLoop >= numberOfLoops - 1 {
                        self.activityDelegate?.changeActivityButtonState()
                        self.timer.invalidate()
                        return
                    }
                    
                    focusSessionModel.isAtWorkTime.toggle()
                    self.activityDelegate?.changeActivityIsAtWorkTime(focusSessionModel.isAtWorkTime)
                    
                    focusSessionModel.totalSeconds = restTime
                    focusSessionModel.timerSeconds = focusSessionModel.totalSeconds
                } else {
                    focusSessionModel.currentLoop += 1
                    focusSessionModel.isAtWorkTime.toggle()
                    self.activityDelegate?.changeActivityIsAtWorkTime(focusSessionModel.isAtWorkTime)
                    
                    focusSessionModel.totalSeconds = workTime
                    focusSessionModel.timerSeconds = focusSessionModel.totalSeconds
                }
        }
    }
    
    func handleActivityDismissed(focusSessionVC: FocusSessionViewController) {
        guard !focusSessionVC.viewModel.didTapFinishButton else { return }
        
        self.focusSessionModel = focusSessionVC.viewModel.focusSessionModel
        self.date = focusSessionVC.viewModel.date
        
        self.isShowingActivity = true
    }
    
    func updateAfterBackground(timeInBackground: Int) {
        guard let focusSessionModel,
              let timerState = focusSessionModel.timerState else { return }
        
        switch focusSessionModel.timerCase {
            case .stopwatch:
                if timeInBackground > 0 && timerState == .starting {
                    focusSessionModel.timerSeconds += timeInBackground
                }
            case .timer, .pomodoro:
                if timeInBackground > 0 && timerState == .starting {
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
            case .pomodoro(let workTime, _, _):
                if focusSessionModel.isAtWorkTime {
                    totalTime = (workTime * focusSessionModel.currentLoop) + (focusSessionModel.totalSeconds - focusSessionModel.timerSeconds)
                } else {
                    totalTime = workTime * (focusSessionModel.currentLoop + 1)
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
