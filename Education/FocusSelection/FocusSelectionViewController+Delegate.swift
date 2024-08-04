//
//  FocusSelectionViewController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

protocol FocusSelectionDelegate: AnyObject {
    func timerButtonTapped()
    func pomodoroButtonTapped()
    func stopWatchButtonTapped()
    func finishButtonTapped()
}

extension FocusSelectionViewController: FocusSelectionDelegate {
    func timerButtonTapped() {
        self.viewModel.selectedTimerCase = .timer
    }
    
    func pomodoroButtonTapped() {
        self.viewModel.selectedTimerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
    }
    
    func stopWatchButtonTapped() {
        self.viewModel.selectedTimerCase = .stopwatch
    }
    
    func finishButtonTapped() {
        if self.viewModel.selectedTimerCase != nil {
            self.coordinator?.showFocusPicker()
        }
    }
}

