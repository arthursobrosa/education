//
//  FocusPickerViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation
import NotificationCenter

@objc 
protocol FocusPickerDelegate: AnyObject {
    func startButtonTapped()
    func dismiss()
    func dismissAll()
}

extension FocusPickerViewController: FocusPickerDelegate {
    func startButtonTapped() {
        viewModel.setFocusSessionModel()
        viewModel.unblockApps()
        coordinator?.showTimer(focusSessionModel: viewModel.focusSessionModel)
        liveActivity.startActivity(endTime: viewModel.focusSessionModel.totalSeconds, title: viewModel.focusSessionModel.subject?.unwrappedName, timerCase: viewModel.focusSessionModel.timerCase)
    }

    func dismiss() {
        coordinator?.dismiss(animated: false)
    }

    func dismissAll() {
        coordinator?.dismissAll()
    }

}
