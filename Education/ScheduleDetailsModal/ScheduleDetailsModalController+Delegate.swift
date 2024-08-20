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
        
        let newFocusSessionModel = FocusSessionModel(subject: self.viewModel.subject, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
    
    func editButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: self.viewModel.schedule, selectedDay: 1)
    }
    
    func dismiss() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func editButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: self.viewModel.schedule, selectedDay: self.viewModel.selectedDayIndex)
    }
    
    func startButtonTapped() {
        let schedule = self.viewModel.schedule
        
        let newFocusSessionModel = FocusSessionModel(isPaused: false, subject: self.viewModel.subject, blocksApps: schedule.blocksApps, isAlarmOn: schedule.imediateAlarm, color: self.color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
}
