//
//  ScheduleDetailsModalController+Delegate.swift
//  Education
//
//  Created by Lucas Cunha on 15/08/24.
//


import UIKit

protocol ScheduleDetailsModalDelegate: AnyObject {
    func startButtonTapped(color: UIColor?, subject: Subject?)
    func editButtonTapped(schedule: Schedule?, title: String?, selectedDay: Int)
    func dismiss()
}

extension ScheduleDetailsModalViewController: ScheduleDetailsModalDelegate {
    func startButtonTapped(color: UIColor?, subject: Subject?) {
        let colorName = self.viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)
        
        let newFocusSessionModel = FocusSessionModel(subject: self.viewModel.subject, color: color)
        
        self.coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }
    
    func editButtonTapped(schedule: Schedule?, title: String?, selectedDay: Int) {
        self.coordinator?.showScheduleDetails(schedule: schedule)
    }
    
    func dismiss() {
        self.coordinator?.dismiss(animated: true)
    }
}
