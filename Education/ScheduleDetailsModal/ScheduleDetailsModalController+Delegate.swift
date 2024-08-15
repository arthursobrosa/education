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
    func dismissAll()
}

extension ScheduleDetailsModalViewController: ScheduleDetailsModalDelegate {
    func startButtonTapped(color: UIColor?, subject: Subject?) {
        self.coordinator?.showFocusSelection(color: color, subject: subject, blocksApps: false)
    }
    
    func editButtonTapped(schedule: Schedule?, title: String?, selectedDay: Int) {
        self.coordinator?.showScheduleDetails(schedule: schedule, title: title, selectedDay: selectedDay)
    }
    
    func dismiss() {
        self.coordinator?.dismiss()
    }
    
    func dismissAll() {
        self.coordinator?.dismissAll()
    }
}
