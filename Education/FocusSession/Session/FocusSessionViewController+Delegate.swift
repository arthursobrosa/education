//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

protocol FocusSessionDelegate: AnyObject {
    func pauseResumeButtonTapped()
    func saveFocusSession()
    func unblockApps()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func pauseResumeButtonTapped() {
        self.viewModel.pauseResumeButtonTapped()
        
        let isPaused = !(self.viewModel.timerState.value == .starting)
        self.setNavigationTitle(isPaused: isPaused)
    }
    
    func saveFocusSession() {
        self.finishAndDismiss()
    }
    
    func unblockApps() {
        self.model.removeShields()
    }
}
