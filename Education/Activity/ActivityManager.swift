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
    
    var timer = Timer()
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            switch self.timerCase {
                case .stopwatch:
                    self.timerSeconds += 1
                case .timer, .pomodoro:
                    self.timerSeconds -= 1
            }
            
            if self.timerSeconds <= 0 {
                // handle timer end
                self.timer.invalidate()
                self.activityDelegate?.changeActivityButtonState()
                return
            }
        }
    }
    
    var isShowingActivity: Bool = false {
        didSet {
            if isShowingActivity {
                self.activityDelegate?.setActivityView(color: self.color, 
                                                       subject: self.subject,
                                                       totalSeconds: self.totalSeconds,
                                                       timerSeconds: self.timerSeconds,
                                                       timerCase: self.timerCase,
                                                       isPaused: self.isPaused)
                
                if !isPaused {
                    self.startTimer()
                }
                
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
    
    func handleActivityDismissed(_ dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let focusSessionViewController = dismissed.children.first as? FocusSessionViewController,
              !focusSessionViewController.viewModel.didTapFinishButton else { return nil }

        ActivityManager.shared.color = focusSessionViewController.color
        ActivityManager.shared.subject = focusSessionViewController.viewModel.subject
        ActivityManager.shared.totalSeconds = focusSessionViewController.viewModel.totalSeconds
        ActivityManager.shared.timerSeconds = focusSessionViewController.viewModel.timerSeconds.value
        ActivityManager.shared.timerCase = focusSessionViewController.viewModel.timerCase
        ActivityManager.shared.isPaused = focusSessionViewController.viewModel.timerState.value == .reseting
        ActivityManager.shared.isShowingActivity = true
        
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
}
