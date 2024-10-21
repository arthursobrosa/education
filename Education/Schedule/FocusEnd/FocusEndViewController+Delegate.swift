//
//  FocusEndViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import Foundation

@objc protocol FocusEndDelegate: AnyObject {
    func didTapSaveButton()
    func didTapDiscardButton()
}

extension FocusEndViewController: FocusEndDelegate {
    func didTapSaveButton() {
        viewModel.activityManager.saveFocusSesssion()
        viewModel.activityManager.resetTimer()
        coordinator?.dismiss(animated: true)
    }
    
    func didTapDiscardButton() {
        viewModel.activityManager.resetTimer()
        coordinator?.dismiss(animated: true)
    }
}
