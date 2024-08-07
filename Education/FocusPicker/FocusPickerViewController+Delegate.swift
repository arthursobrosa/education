//
//  FocusPickerViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

protocol FocusPickerDelegate: AnyObject {
    func startButtonTapped()
    func pomodoroDateChanged(tag: Int, time: Int)
    func dismiss()
}

extension FocusPickerViewController: FocusPickerDelegate {
    func startButtonTapped() {
        self.viewModel.setTimerCase()
        
        guard let timerCase = self.viewModel.timerCase else { return }
        let totalTime = self.viewModel.getTotalTime()
        
        self.coordinator?.showTimer(totalTimeInSeconds: totalTime, subject: self.viewModel.subject, timerCase: timerCase)
    }
    
    func pomodoroDateChanged(tag: Int, time: Int) {
        switch tag {
            case 0:
                self.viewModel.selectedWorkTime = time
            case 1:
                self.viewModel.selectedRestTime = time
            default:
                break
        }
    }
    
    func dismiss() {
        self.coordinator?.dismiss()
    }
}
