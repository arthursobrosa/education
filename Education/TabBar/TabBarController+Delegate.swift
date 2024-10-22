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
        self.activityView.timerSeconds = viewModel.activityManager.timerSeconds
        self.activityView.subject = viewModel.activityManager.subject
        self.activityView.color = viewModel.activityManager.color
        self.activityView.progress = viewModel.activityManager.progress
        
        self.view.addSubview(activityView)
    }
    
    func removeActivityView() {
        self.activityView.removeFromSuperview()
    }
    
    func didTapPlayButton() {
        self.activityViewTapped()
        
        viewModel.activityManager.isPaused.toggle()
    }
}
