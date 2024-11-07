//
//  FocusSubjectDetailsViewController+Delegate.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//
import Foundation

@objc
protocol FocusSubjectDetailsDelegate: AnyObject {
    func didTapSaveButton()
    func didTapDiscardButton()
}

extension FocusSubjectDetailsViewController: FocusSubjectDetailsDelegate {
    func didTapSaveButton() {
//        coordinator?.dismiss(animated: true)
//        viewModel.updateActivityManagerSubject()
//        viewModel.activityManager.saveFocusSesssion()
//        viewModel.activityManager.resetTimer()
    }

    func didTapDiscardButton() {
//        viewModel.activityManager.resetTimer()
//        coordinator?.dismiss(animated: true)
    }
}
