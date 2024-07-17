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
}

extension FocusSessionViewController: FocusSessionDelegate {
    func pauseResumeButtonTapped() {
        self.viewModel.pauseResumeButtonTapped()
    }
    
    func saveFocusSession() {
        self.viewModel.saveFocusSession()
        self.coordinator?.dismiss()
    }
}
