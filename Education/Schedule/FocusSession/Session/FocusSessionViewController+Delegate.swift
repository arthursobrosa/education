//
//  FocusSessionViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/07/24.
//

import Foundation

protocol FocusSessionDelegate: AnyObject {
    func pauseResumeButtonTapped()
    func finishAndDismiss()
    func unblockApps()
}

extension FocusSessionViewController: FocusSessionDelegate {
    func pauseResumeButtonTapped() {
        self.viewModel.pauseResumeButtonTapped()
        self.setNavigationTitle()
    }
    
    func finishAndDismiss() {
        self.viewModel.saveFocusSession()
        self.viewModel.didTapFinishButton = true
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func unblockApps() {
        BlockAppsMonitor.shared.removeShields()
    }
}
