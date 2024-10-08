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
        let subject = viewModel.getSubject()
        
        let title = String(localized: "timeIsUp")
        let body = subject != nil ?
            String(localized: "activityEndCongratulations") + (subject!.unwrappedName)  + " 🎉" :
            String(localized: "noActivityEndCongratulations")
        
        return NotificationComponentView(title: title, body: body)
    }
    
    func dismissButtonTapped() {
        viewModel.changePauseStatus()
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func visibilityButtonTapped() {
        viewModel.changeTimerVisibility()
        
        self.updateViewLabels()
        self.focusSessionView.setVisibilityButton(isActive: viewModel.isTimerVisible())
    }
    
    func pauseResumeButtonTapped() {
        let isPaused = viewModel.getPauseStatus()
        
        if !isPaused && viewModel.prefersStatusBarHidden {
            viewModel.prefersStatusBarHidden.toggle()
            focusSessionView.changeButtonsVisibility(isHidden: viewModel.prefersStatusBarHidden)
        }
        
        if isPaused && !viewModel.prefersStatusBarHidden {
            viewModel.prefersStatusBarHidden.toggle()
            focusSessionView.changeButtonsVisibility(isHidden: viewModel.prefersStatusBarHidden)
        }
        
        viewModel.pauseResumeButtonTapped()
    }
    
    func didFinish() {
        self.viewModel.saveFocusSession()
        self.viewModel.didTapFinish = true
        
        self.coordinator?.dismiss(animated: true)
        
        BlockAppsMonitor.shared.removeShields()
    }
    
    func didRestart() {
        self.focusSessionView.showFocusAlert(false)
        self.focusSessionView.isPaused = false
        viewModel.restartActivity()
    }
    
    func okButtonPressed() {
        self.focusSessionView.showEndNotification(false)
        self.didFinish()
    }
    
    func cancelButtonPressed() {
        self.focusSessionView.showFocusAlert(false)
    }
}
