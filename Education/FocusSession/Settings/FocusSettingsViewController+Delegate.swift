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
        
        var totalTimeInSeconds: Int
        
        switch self.viewModel.timerCase {
            case .stopwatch:
                totalTimeInSeconds = 0
            case .timer:
                totalTimeInSeconds = Int(selectedTime)
            case .pomodoro(let workTime, let restTime, let numberOfLoops):
                totalTimeInSeconds = workTime
        }
        
        self.coordinator?.showTimer(totalTimeInSeconds: totalTimeInSeconds, subjectID: self.viewModel.subjectID, timerCase: self.viewModel.timerCase)
        
        if self.viewModel.blockApps {
            self.model.apllyShields()
        }
    }
}
