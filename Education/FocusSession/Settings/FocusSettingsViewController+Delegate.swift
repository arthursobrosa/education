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
        
//        var totalSeconds: Int
//        
//        self.viewModel.timerCase = .pomodoro(workTime: 10, restTime: 5, numberOfLoops: 2)
//        
//        switch self.viewModel.timerCase {
//            case .stopwatch:
//                totalSeconds = 0
//            case .timer:
//                totalSeconds = Int(selectedTime)
//            case .pomodoro(let workTime, _, _):
//                totalSeconds = workTime
//        }
        
//        self.coordinator?.showTimer(navigationDelegate: self, totalSeconds: totalSeconds, timerSeconds: totalSeconds, subject: self.viewModel.selectedSubject, timerCase: self.viewModel.timerCase)
        
        if self.viewModel.blockApps {
            self.model.apllyShields()
        }
    }
}
