//
//  ScheduleDetailsViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

protocol ScheduleDetailsDelegate: AnyObject {
    func saveSchedule()
}

extension ScheduleDetailsViewController: ScheduleDetailsDelegate {
    func saveSchedule() {
        if self.viewModel.selectedSubjectName.isEmpty {
            self.showNoSubjectAlert()
            return
        }
        
        if self.viewModel.selectedStartTime >= self.viewModel.selectedEndTime {
            self.showInvalidDatesAlert(forExistingSchedule: false)
            return
        }
        
        if !self.viewModel.isNewScheduleAvailable() {
            self.showInvalidDatesAlert(forExistingSchedule: true)
            return
        }
        
        self.viewModel.saveSchedule()
        self.coordinator?.dismiss(animated: true)
    }
}
