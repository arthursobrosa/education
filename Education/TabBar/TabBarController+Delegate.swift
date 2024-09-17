//
//  TabBarController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

// MARK: - Activity
protocol TabBarDelegate: AnyObject {
    func addActivityView()
    func removeActivityView()
    func didTapPlayButton()
}

extension TabBarController: TabBarDelegate {
    func addActivityView() {
        self.activityView.timerSeconds = ActivityManager.shared.timerSeconds
        self.activityView.subject = ActivityManager.shared.subject
        self.activityView.color = ActivityManager.shared.color
        self.activityView.progress = ActivityManager.shared.progress
        
        self.view.addSubview(activityView)
    }
    
    func removeActivityView() {
        self.activityView.removeFromSuperview()
    }
    
    func didTapPlayButton() {
        self.activityViewTapped()
        
        ActivityManager.shared.isPaused.toggle()
    }
}
