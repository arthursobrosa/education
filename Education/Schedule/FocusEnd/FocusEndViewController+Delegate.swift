//
//  FocusEndViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Foundation

@objc 
protocol FocusEndDelegate: AnyObject {
    func didTapSaveButton()
    func didTapDiscardButton()
    func updateNotes(with text: String)
}

extension FocusEndViewController: FocusEndDelegate {
    func didTapSaveButton() {
        coordinator?.dismiss(animated: true)
        viewModel.updateActivityManagerSubject()
        viewModel.activityManager.saveFocusSesssion()
        viewModel.activityManager.resetTimer()
    }

    func didTapDiscardButton() {
        viewModel.activityManager.resetTimer()
        coordinator?.dismiss(animated: true)
    }
    
    func updateNotes(with text: String) {
        viewModel.notes = text
    }
}
