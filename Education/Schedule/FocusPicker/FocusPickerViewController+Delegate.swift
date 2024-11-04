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
        liveActivity.liveActivityManaging.startActivity(endTime: Date().addingTimeInterval(Double(viewModel.focusSessionModel.totalSeconds)))
    }

    func dismiss() {
        coordinator?.dismiss(animated: false)
    }

    func dismissAll() {
        coordinator?.dismissAll()
    }

}
