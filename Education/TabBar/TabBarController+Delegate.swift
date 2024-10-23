//
//  TabBarController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

// MARK: - Activity
@objc protocol TabBarDelegate: AnyObject {
    func addActivityView()
    func removeActivityView()
    func didTapPlayButton()
}

extension TabBarController: TabBarDelegate {
    func addActivityView() {
        activityView.timerSeconds = viewModel.activityManager.timerSeconds
        activityView.subject = viewModel.activityManager.subject
        activityView.color = viewModel.activityManager.color
        activityView.progress = viewModel.activityManager.progress
        
        view.addSubview(activityView)
        
        guard case .pomodoro = viewModel.activityManager.timerCase,
              !viewModel.activityManager.isAtWorkTime else { return }
        
        activityView.liveActivityButton?.updatePauseResumeButton(isPaused: false)
    }
    
    func removeActivityView() {
        activityView.removeFromSuperview()
    }
    
    func didTapPlayButton() {
        activityViewTapped()
        
        viewModel.activityManager.isPaused.toggle()
    }
}
