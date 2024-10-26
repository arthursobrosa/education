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
        var timerCase: TimerCase = .timer

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

        viewModel.focusSessionModel.timerCase = timerCase
    }

    func continueButtonTapped() {
        switch viewModel.focusSessionModel.timerCase {
        case .stopwatch:
            coordinator?.showTimer(focusSessionModel: viewModel.focusSessionModel)
        case .timer:
            coordinator?.showFocusPicker(focusSessionModel: viewModel.focusSessionModel)
        case .pomodoro:
            let pomodoroCase: TimerCase = .pomodoro(workTime: 25 * 60, restTime: 5 * 60, numberOfLoops: 2)
            viewModel.focusSessionModel.timerCase = pomodoroCase

            coordinator?.showFocusPicker(focusSessionModel: viewModel.focusSessionModel)
        }
    }

    func dismiss() {
        coordinator?.dismiss(animated: true)
    }

    func dismissAll() {
        coordinator?.dismissAll()
    }
}
