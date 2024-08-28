//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

protocol FocusSessionDelegate: AnyObject {
    func pauseResumeButtonTapped()
    func didTapFinishButton()
    func didTapRestartButton()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func pauseResumeButtonTapped() {
        ActivityManager.shared.isPaused.toggle()

        self.setNavigationTitle()
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
