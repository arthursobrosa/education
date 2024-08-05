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
    func cancelButtonTapped()
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
        if self.viewModel.selectedTimerCase != nil {
            self.coordinator?.showFocusPicker()
        }
    }
    
    func cancelButtonTapped() {
        
    }
}

