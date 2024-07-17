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
        self.viewModel.saveSchedule()
        self.dismiss(animated: true)
    }
}
