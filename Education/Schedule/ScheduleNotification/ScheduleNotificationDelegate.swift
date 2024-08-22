//
//  ScheduleNotificationDelegate.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//


import UIKit

protocol ScheduleNotificationDelegate: AnyObject {
    func startButtonTapped()
    func dismiss()
}

extension ScheduleNotificationViewController: ScheduleNotificationDelegate {
    
    func startButtonTapped() {
        let colorName = self.viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        
        let newFocusSessionModel = FocusSessionModel(isPaused: false, subject: self.viewModel.subject, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
    
    func dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
    
}
