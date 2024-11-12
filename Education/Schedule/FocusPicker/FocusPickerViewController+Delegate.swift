//
//  FocusPickerViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import Foundation

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
//        liveActivity.startActivity(
//            endTime: Date().addingTimeInterval(TimeInterval(viewModel.focusSessionModel.totalSeconds)),
//            title: viewModel.focusSessionModel.subject?.unwrappedName ?? "Free Focus"
//        )
    }

    func dismiss() {
        coordinator?.dismiss(animated: false)
    }

    func dismissAll() {
        coordinator?.dismissAll()
    }
}
