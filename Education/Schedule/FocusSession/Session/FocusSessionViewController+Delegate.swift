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
    func didTapRestartButton()
    func okButtonPressed()
    func cancelButtonPressed()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func dismissButtonTapped() {
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
    
    func didTapRestartButton() {
        ActivityManager.shared.restartActivity()
    }
    
    func okButtonPressed() {
        self.hideEndNotification()
        self.didFinish()
    }
    
    func cancelButtonPressed() {
        self.hideFinishNotification()
    }
}
