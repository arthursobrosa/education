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
        
        self.viewModel.selectedTimerCase = timerCase
    }
    
    func continueButtonTapped() {
        guard let timerCase = self.viewModel.selectedTimerCase else { return }
        
        switch timerCase {
            case .stopwatch:
                self.coordinator?.showTimer(transitioningDelegate: self, timerState: nil, totalSeconds: 0, timerSeconds: 0, subject: self.viewModel.subject, timerCase: timerCase)
            case .timer, .pomodoro:
                self.coordinator?.showFocusPicker(timerCase: timerCase)
        }
    }
    
    func dismiss() {
        self.changeViewVisibility(isHidden: false)
        self.coordinator?.dismiss()
    }
}

