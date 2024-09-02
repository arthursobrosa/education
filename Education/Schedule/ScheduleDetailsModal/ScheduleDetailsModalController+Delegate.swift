//
//  ScheduleDetailsModalController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//


import UIKit

protocol ScheduleDetailsModalDelegate: AnyObject {

    func startButtonTapped()
    func editButtonTapped()
    func dismiss()
}

extension ScheduleDetailsModalViewController: ScheduleDetailsModalDelegate {
    func startButtonTapped() {
        let colorName = self.viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        
        let newFocusSessionModel = FocusSessionModel(subject: self.viewModel.subject, blocksApps: self.viewModel.schedule.blocksApps, isAlarmOn: self.viewModel.schedule.imediateAlarm, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
    
    func editButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: self.viewModel.schedule, selectedDay: 1)
    }
    
    func dismiss() {
        self.coordinator?.dismiss(animated: true)
    }
}
