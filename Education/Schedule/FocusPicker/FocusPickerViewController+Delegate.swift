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
    func dismissAll()
}

extension FocusPickerViewController: FocusPickerDelegate {
    func startButtonTapped() {
        self.viewModel.setFocusSessionModel()
        
        ActivityManager.shared.finishSession()
        
        BlockAppsMonitor.shared.removeShields()
        
        self.coordinator?.showTimer(focusSessionModel: self.viewModel.focusSessionModel)
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
        self.coordinator?.dismiss(animated: true)
    }
    
    func dismissAll() {
        self.coordinator?.dismissAll(animated: true)
    }
}
