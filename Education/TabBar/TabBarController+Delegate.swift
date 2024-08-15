//
//  TabBarController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

// MARK: - Activity
protocol ActivityDelegate: AnyObject {
    func setActivityView()
    func updateActivityView()
    func changeActivityButtonState()
    func changeActivityVisibility(isShowing: Bool)
    func removeActivityView()
}

extension TabBarController: ActivityDelegate {
    func setActivityView() {
        guard let timerState = ActivityManager.shared.timerState else { return }
        
        self.activityView.color = ActivityManager.shared.color
        self.activityView.subject = ActivityManager.shared.subject
        self.activityView.totalSeconds = ActivityManager.shared.totalSeconds
        self.activityView.timerSeconds = ActivityManager.shared.timerSeconds
        self.activityView.isAtWorkTime = ActivityManager.shared.isAtWorkTime
        self.activityView.isPaused = timerState == .reseting
        
        self.view.addSubview(activityView)
    }
    
    func updateActivityView() {
        let timerSeconds = ActivityManager.shared.timerSeconds
        
        self.activityView.timerSeconds = timerSeconds
    }
    
    func changeActivityButtonState() {
        self.activityView.isPaused.toggle()
    }
    
    func changeActivityVisibility(isShowing: Bool) {
        self.activityView.alpha = isShowing ? 1 : 0
    }
    
    func removeActivityView() {
        self.activityView.removeFromSuperview()
    }
}
