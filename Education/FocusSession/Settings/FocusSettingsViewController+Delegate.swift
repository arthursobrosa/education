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
        
        self.viewModel.timerCase = .pomodoro(workTime: 10, restTime: 5, numberOfLoops: 2)
        
        switch self.viewModel.timerCase {
            case .stopwatch:
                totalTimeInSeconds = 0
            case .timer:
                totalTimeInSeconds = Int(selectedTime)
            case .pomodoro(let workTime, _, _):
                totalTimeInSeconds = workTime
        }
        
        self.coordinator?.showTimer(totalTimeInSeconds: totalTimeInSeconds, subject: self.viewModel.selectedSubject, timerCase: self.viewModel.timerCase)
        
        if self.viewModel.blockApps {
            self.model.apllyShields()
        }
    }
}
