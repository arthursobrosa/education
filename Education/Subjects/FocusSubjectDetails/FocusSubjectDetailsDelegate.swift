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
    func didTapDeleteButton()
    func didTapChevronButton()
    func didTapEditButton()
    func didTapCancelButton()
}

extension FocusSubjectDetailsViewController: FocusSubjectDetailsDelegate {
    func didTapChevronButton() {
        coordinator?.dismiss(animated: true)
    }
    
    func didTapSaveButton() {
        coordinator?.dismiss(animated: true)
        viewModel.updateFocusSession()
    }

    func didTapDeleteButton() {
        viewModel.removeFocusSession()
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
}
