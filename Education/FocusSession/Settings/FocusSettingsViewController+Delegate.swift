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
        let selectedTime = self.viewModel.getSelectedTime()
        
        if selectedTime <= 0 {
            self.showInvalidDateAlert()
            return
        }
        
        self.coordinator?.showTimer(totalTimeInSeconds: Int(selectedTime), subjectID: self.viewModel.subjectID)
    }
}
