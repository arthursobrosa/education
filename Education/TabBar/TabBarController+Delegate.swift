//
//  TabBarController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

// MARK: - Activity
protocol ActivityDelegate: AnyObject {
    func setActivityView(focusSessionModel: FocusSessionModel?)
    func updateActivityView(timerSeconds: Int)
    func changeActivityButtonState()
    func changeActivityIsAtWorkTime(_ isAtWorkTime: Bool)
    func changeActivityVisibility(isShowing: Bool)
    func removeActivityView()
}

extension TabBarController: ActivityDelegate {
    func setActivityView(focusSessionModel: FocusSessionModel?) {
        guard let focusSessionModel else { return }
        
        self.activityView.color = focusSessionModel.color
        self.activityView.subject = focusSessionModel.subject
        self.activityView.totalSeconds = focusSessionModel.totalSeconds
        self.activityView.timerSeconds = focusSessionModel.timerSeconds
        self.activityView.isPaused = focusSessionModel.isPaused
        
        self.view.addSubview(activityView)
    }
    
    func updateActivityView(timerSeconds: Int) {
        self.activityView.timerSeconds = timerSeconds
    }
    
    func changeActivityButtonState() {
        self.activityView.isPaused.toggle()
    }
    
    func changeActivityIsAtWorkTime(_ isAtWorkTime: Bool) {
        self.activityView.isAtWorkTime = isAtWorkTime
    }
    
    func changeActivityVisibility(isShowing: Bool) {
        self.activityView.alpha = isShowing ? 1 : 0
    }
    
    func removeActivityView() {
        self.activityView.removeFromSuperview()
    }
}

// MARK: - Transitioning Delegate
extension TabBarController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        ActivityManager.shared.handleActivityDismissed(dismissed)
    }
}
