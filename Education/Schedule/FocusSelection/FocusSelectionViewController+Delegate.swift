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
        
        self.viewModel.selectedTimerCase = timerCase
    }
    
    func continueButtonTapped() {
        guard let timerCase = self.viewModel.selectedTimerCase else { return }
        
        switch timerCase {
            case .stopwatch:
                ActivityManager.shared.finishSession()
                
                self.coordinator?.showTimer(transitioningDelegate: self, timerState: nil, totalSeconds: 0, timerSeconds: 0, subject: self.viewModel.subject, timerCase: timerCase, isAtWorkTime: true, blocksApps: self.viewModel.blocksApps, isTimeCountOn: true, isAlarmOn: false)
            case .timer:
                self.coordinator?.showFocusPicker(timerCase: timerCase, blocksApps: self.viewModel.blocksApps)
            case .pomodoro:
                let pomodoroCase: TimerCase = .pomodoro(workTime: 25 * 60, restTime: 5 * 60, numberOfLoops: 2)
                
                self.coordinator?.showFocusPicker(timerCase: pomodoroCase, blocksApps: self.viewModel.blocksApps)
        }
    }
    
    func dismiss() {
        self.coordinator?.dismiss()
    }
    
    func dismissAll() {
        self.coordinator?.dismissAll()
    }
}

