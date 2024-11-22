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
    func didCancel()
    func didDiscard()
    func updateNotes(with text: String)
}

extension FocusEndViewController: FocusEndDelegate {
    func didTapSaveButton() {
        coordinator?.dismiss(animated: true)
        viewModel.updateActivityManagerSubject()
        viewModel.activityManager.saveFocusSesssion(withNotes: viewModel.notes)
        viewModel.activityManager.resetTimer()
    }

    func didTapDiscardButton() {
        let alertCase: AlertCase = .discardingFocusSession
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: focusEndView)
        focusEndView.discardAlertView.config = alertConfig
        focusEndView.discardAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        focusEndView.discardAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        focusEndView.changeAlertVisibility(isShowing: true)
    }
    
    func didCancel() {
        focusEndView.changeAlertVisibility(isShowing: false)
    }
    
    func didDiscard() {
        viewModel.activityManager.resetTimer()
        coordinator?.dismiss(animated: true)
    }
    
    func updateNotes(with text: String) {
        viewModel.notes = text
    }
}
