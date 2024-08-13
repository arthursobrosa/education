//
//  FocusSelectionViewController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

protocol FocusSelectionDelegate: AnyObject {
    func selectionButtonTapped(tag: Int)
    func continueButtonTapped()
    func dismiss()
    func dismissAll()
}

extension FocusSelectionViewController: FocusSelectionDelegate {
    func selectionButtonTapped(tag: Int) {
        var timerCase: TimerCase?
        
        switch tag {
            case 0:
                timerCase = .timer
            case 1:
                timerCase = .pomodoro(workTime: 0, restTime: 0, numberOfLoops: 0)
            case 2:
                timerCase = .stopwatch
            default:
                break
        }
        
        guard let timerCase else { return }
        
        self.viewModel.focusSessionModel.timerCase = timerCase
    }
    
    func continueButtonTapped() {
        switch self.viewModel.focusSessionModel.timerCase {
            case .stopwatch:
                ActivityManager.shared.finishSession()
                
                self.coordinator?.showTimer(focusSessionModel: self.viewModel.focusSessionModel)
            case .timer:
                self.coordinator?.showFocusPicker(focusSessionModel: self.viewModel.focusSessionModel)
            case .pomodoro:
                let pomodoroCase: TimerCase = .pomodoro(workTime: 25 * 60, restTime: 5 * 60, numberOfLoops: 2)
                self.viewModel.focusSessionModel.timerCase = pomodoroCase
                
                self.coordinator?.showFocusPicker(focusSessionModel: self.viewModel.focusSessionModel)
        }
    }
    
    func dismiss() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func dismissAll() {
        self.coordinator?.dismissAll(animated: true)
    }
}

