//
//  FocusSubjectDetailsViewController+Delegate.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//
import Foundation

@objc
protocol FocusSubjectDetailsDelegate: AnyObject {
    func didTapChevronButton()
    func didTapEditButton()
    func didTapCancelButton()
    func didTapSaveButton()
    func didTapDeleteButton()
    func didCancelDeletion()
    func didDelete()
}

extension FocusSubjectDetailsViewController: FocusSubjectDetailsDelegate {
    func didTapChevronButton() {
        coordinator?.dismiss(animated: true)
    }
    
    func didTapEditButton() {
        focusSubjectDetails.changeNotesTextViewState(isEditable: true)
        focusSubjectDetails.changeButtonsVisibility(isEditing: true)
        focusSubjectDetails.changeSaveButtonVisibility(isShowing: true)
    }
    
    func didTapCancelButton() {
        focusSubjectDetails.changeNotesTextViewState(isEditable: false)
        focusSubjectDetails.changeButtonsVisibility(isEditing: false)
        focusSubjectDetails.changeSaveButtonVisibility(isShowing: false)
        
        let originalNotes = viewModel.focusSession.unwrappedNotes
        focusSubjectDetails.updateNotesTextViewText(originalNotes)
        focusSubjectDetails.changeNotesPlaceholderVisibility(isShowing: originalNotes.isEmpty)
    }
    
    func didTapSaveButton() {
        coordinator?.dismiss(animated: true)
        viewModel.updateFocusSession()
    }

    func didTapDeleteButton() {
        let alertCase: AlertCase = .deletingFocusSession
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: focusSubjectDetails)
        focusSubjectDetails.deleteAlertView.config = alertConfig
        focusSubjectDetails.deleteAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        focusSubjectDetails.deleteAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        focusSubjectDetails.changeAlertVisibility(isShowing: true)
    }
    
    func didCancelDeletion() {
        focusSubjectDetails.changeAlertVisibility(isShowing: false)
    }
    
    func didDelete() {
        viewModel.removeFocusSession()
        coordinator?.dismiss(animated: true)
    }
}
