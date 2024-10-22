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
        let colorName = viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        let scheduleID = viewModel.schedule.unwrappedID
        
        let newFocusSessionModel = FocusSessionModel(scheduleID: scheduleID, subject: viewModel.subject, blocksApps: viewModel.schedule.blocksApps, isAlarmOn: viewModel.schedule.imediateAlarm, color: color)
        
        coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
    
    func editButtonTapped() {
        coordinator?.showScheduleDetails(schedule: viewModel.schedule, selectedDay: 1)
    }
    
    func dismiss() {
        coordinator?.dismiss(animated: true)
    }
}
