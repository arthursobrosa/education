//
//  ScheduleDetailsModalController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//


import UIKit

protocol ScheduleDetailsModalDelegate: AnyObject {
    func dismiss()
    func editButtonTapped()
    func startButtonTapped()
}

extension ScheduleDetailsModalViewController: ScheduleDetailsModalDelegate {
    func dismiss() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func editButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: self.viewModel.schedule, selectedDay: self.viewModel.selectedDayIndex)
    }
    
    func startButtonTapped() {
        let newFocusSessionModel = FocusSessionModel(subject: self.viewModel.subject, color: self.color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}
