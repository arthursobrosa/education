//
//  SubjectCreationViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 22/08/24.
//

import UIKit

@objc
protocol SubjectCreationDelegate: AnyObject {
    func textFieldDidChange(newText: String)
    func didTapSaveButton()
    func didTapDeleteButton()
    func didCancel()
    func didDelete()
    func didTapCloseButton()
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        subjectName = newText
        subjectCreationView.changeSaveButtonState(isEnabled: !newText.isEmpty)
    }

    func didTapSaveButton() {
        guard let subjectName else { return }
        
        let canSaveSubject = viewModel.canSaveSubject(withName: subjectName)
        
        if canSaveSubject {
            viewModel.saveSubject(withName: subjectName)
            coordinator?.dismiss(animated: true)
        } else {
            showUsedSubjectNameAlert(message: String(localized: "subjectCreationUsedName"))
        }
    }

    func didTapDeleteButton() {
        guard let subjectName else { return }
        
        let alertCase: AlertCase = .deletingSubject(subjectName: subjectName)
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: view)
        deleteAlertView.config = alertConfig
        deleteAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        deleteAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        
        if viewModel.currentEditingSubject != nil {
            changeDeleteAlertVisibility(isShowing: true)
        }
    }
    
    func didCancel() {
        changeDeleteAlertVisibility(isShowing: false)
    }
    
    func didDelete() {
        guard let subject = viewModel.currentEditingSubject else { return }
        
        viewModel.removeSubject(subject: subject)
        coordinator?.dismiss(animated: true)
    }
    
    func didTapCloseButton() {
        coordinator?.dismiss(animated: true)
    }
}
