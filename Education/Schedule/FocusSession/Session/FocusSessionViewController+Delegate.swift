//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

@objc protocol FocusSessionDelegate: AnyObject {
    func dismissButtonTapped()
    func visibilityButtonTapped()
    func pauseResumeButtonTapped()
    func didFinish()
    func didRestart()
    func okButtonPressed()
    func cancelButtonPressed()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func dismissButtonTapped() {
        if !ActivityManager.shared.isPaused {
            ActivityManager.shared.isPaused = true
        }
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func visibilityButtonTapped() {
        ActivityManager.shared.isTimeCountOn.toggle()
        
        self.updateViewLabels()
        self.focusSessionView.setVisibilityButton(isActive: ActivityManager.shared.isTimeCountOn)
    }
    
    func pauseResumeButtonTapped() {
        ActivityManager.shared.isPaused.toggle()
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
        ActivityManager.shared.restartActivity()
    }
    
    func okButtonPressed() {
        self.focusSessionView.showEndNotification(false)
        self.didFinish()
    }
    
    func cancelButtonPressed() {
        self.focusSessionView.showFocusAlert(false)
    }
}
