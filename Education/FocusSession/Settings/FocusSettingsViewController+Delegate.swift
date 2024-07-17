//
//  FocusSettingsViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

protocol FocusSessionSettingsDelegate: AnyObject {
    func startButtonTapped()
}

extension FocusSessionSettingsViewController: FocusSessionSettingsDelegate {
    func startButtonTapped() {
        if self.viewModel.selectedTime <= 0 {
            self.showInvalidDateAlert()
            return
        }
        
        self.coordinator?.showTimer(totalTimeInSeconds: Int(self.viewModel.selectedTime), subjectID: self.viewModel.subjectID)
        
        self.model.apllyShields()
    }
}
