//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

@objc protocol FocusSessionDelegate: AnyObject {
    func createNotificationComponent() -> NotificationComponentView
    func dismissButtonTapped()
    func visibilityButtonTapped()
    func pauseResumeButtonTapped()
    func didFinish()
    func didRestart()
    func okButtonPressed()
    func cancelButtonPressed()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func createNotificationComponent() -> NotificationComponentView {
        let subject = viewModel.activityManager.subject
        
        let title = String(localized: "timeIsUp")
        let body = subject != nil ?
            String(localized: "activityEndCongratulations") + (subject!.unwrappedName)  + " 🎉" :
            String(localized: "noActivityEndCongratulations")
        
        return NotificationComponentView(title: title, body: body)
    }
    
    func dismissButtonTapped() {
        viewModel.changePauseStatus()
        
        coordinator?.dismiss(animated: true)
    }
    
    func visibilityButtonTapped() {
        viewModel.activityManager.isTimeCountOn.toggle()
        
        updateViewLabels()
        let isTimerVisible = viewModel.activityManager.isTimeCountOn
        focusSessionView.setVisibilityButton(isActive: isTimerVisible)
    }
    
    func pauseResumeButtonTapped() {
        if viewModel.shouldChangeVisibility() {
            focusSessionView.changeButtonsVisibility(isHidden: viewModel.prefersStatusBarHidden)
        }
        
        viewModel.pauseResumeButtonTapped()
    }
    
    func didFinish() {
        viewModel.activityManager.saveFocusSesssion()
        viewModel.didTapFinish = true
        
        coordinator?.dismiss(animated: true)
        
        viewModel.unblockApps()
    }
    
    func didRestart() {
        focusSessionView.showFocusAlert(false)
        focusSessionView.isPaused = false
        viewModel.activityManager.restartActivity()
    }
    
    func okButtonPressed() {
        focusSessionView.showEndNotification(false)
        didFinish()
    }
    
    func cancelButtonPressed() {
        focusSessionView.showFocusAlert(false)
    }
}
