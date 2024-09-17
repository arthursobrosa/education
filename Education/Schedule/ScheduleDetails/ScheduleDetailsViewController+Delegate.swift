//
//  ScheduleDetailsViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol ScheduleDetailsDelegate: AnyObject {
    func deleteSchedule()
    func saveSchedule()
}

extension ScheduleDetailsViewController: ScheduleDetailsDelegate {
    func deleteSchedule() {
        let alertController = UIAlertController(title: String(localized: "activityDeletionTitle"), message: String(localized: "activityDeletionMessage"), preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: String(localized: "yes"), style: .destructive) { _ in
            guard let schedule = self.viewModel.schedule else { return }
            NotificationService.shared.cancelNotifications(forDate: schedule.unwrappedStartTime)
            self.viewModel.removeSchedule(schedule)
            self.coordinator?.dismiss(animated: true)
        }
        
        let noAction = UIAlertAction(title: String(localized: "no"), style: .cancel)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true)
    }
    
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
