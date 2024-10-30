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

        let yesAction = UIAlertAction(title: String(localized: "yes"), style: .destructive) { [weak self] _ in
            guard let self else { return }

            self.viewModel.cancelNotifications()
            self.viewModel.removeSchedule()

            self.coordinator?.dismiss(animated: true)
        }

        let noAction = UIAlertAction(title: String(localized: "no"), style: .cancel)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true)
    }

    func saveSchedule() {
        if viewModel.selectedSubjectName.isEmpty {
            showNoSubjectAlert()
            return
        }

        if viewModel.selectedStartTime >= viewModel.selectedEndTime {
            showInvalidDatesAlert(forExistingSchedule: false)
            return
        }

        if !viewModel.isNewScheduleAvailable() {
            showInvalidDatesAlert(forExistingSchedule: true)
            return
        }

        viewModel.saveSchedule()
        coordinator?.dismiss(animated: true)
    }
}
