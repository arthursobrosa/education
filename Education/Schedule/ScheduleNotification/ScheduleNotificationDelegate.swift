//
//  ScheduleNotificationDelegate.swift
//  Education
//
//  Created by Lucas Cunha on 19/08/24.
//

import UIKit

protocol ScheduleNotificationDelegate: AnyObject {
    func startButtonTapped()
    func dismiss()
}

extension ScheduleNotificationViewController: ScheduleNotificationDelegate {
    func startButtonTapped() {
        let colorName = viewModel.subject.unwrappedColor
        let color = UIColor(named: colorName)

        let newFocusSessionModel = FocusSessionModel(subject: viewModel.subject, color: color)

        coordinator?.showFocusSelection(focusSessionModel: newFocusSessionModel)
    }

    func dismiss() {
        navigationController?.dismiss(animated: true)
    }
}
