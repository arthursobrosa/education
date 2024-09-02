//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

protocol FocusSessionDelegate: AnyObject {
    func dismissButtonTapped()
    func visibilityButtonTapped()
    func pauseResumeButtonTapped()
    func didTapFinishButton()
    func didTapRestartButton()
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
    
    func didTapFinishButton() {
        self.viewModel.saveFocusSession()
        self.viewModel.didTapFinish = true
        
        self.coordinator?.dismiss(animated: true)
        
        BlockAppsMonitor.shared.removeShields()
    }
    
    func didTapRestartButton() {
        ActivityManager.shared.restartActivity()
    }
}
