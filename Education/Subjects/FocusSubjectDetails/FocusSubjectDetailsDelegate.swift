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
        viewModel.updateFocusSessionComment()
    }

    func didTapDiscardButton() {
        viewModel.removeFocusSession()
        coordinator?.dismiss(animated: true)
    }
    
    func didTapEditButton() {
        focusSubjectDetails.notesView.isEditable = true
        focusSubjectDetails.notesView.becomeFirstResponder()
        
        focusSubjectDetails.showCancelButton()
        focusSubjectDetails.hideEditButton()
    }
    
    func didTapCancelButton() {
//        focusSubjectDetails.notesView.text = originalNotesText
//        viewModel.notes = originalNotesText
        focusSubjectDetails.notesView.isEditable = false
        focusSubjectDetails.notesView.resignFirstResponder()
        
        focusSubjectDetails.hideCancelButton()
        focusSubjectDetails.showEditButton()
        focusSubjectDetails.hideSabeButton()
    }
}
