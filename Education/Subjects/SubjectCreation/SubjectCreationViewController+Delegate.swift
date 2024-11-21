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
    func didTapCloseButton()
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        subjectName = newText
        changeSaveButtonState(isEnabled: !newText.isEmpty)
    }

    func didTapSaveButton() {
        guard let subjectName else { return }
        
        if viewModel.currentEditingSubject != nil {
            viewModel.updateSubject(name: subjectName, color: viewModel.selectedSubjectColor.value)
        } else {
            let existingSubjects = viewModel.subjects.value
            if existingSubjects.contains(where: { $0.name?.lowercased() == subjectName.lowercased() }) {
                showAlert(message: String(localized: "subjectCreationUsedName"))
                return
            }

            viewModel.createSubject(name: subjectName)
        }

        coordinator?.dismiss(animated: true)
    }
    
    func didTapCloseButton() {
        coordinator?.dismiss(animated: true)
    }

    func didTapDeleteButton() {
        if let subject = viewModel.currentEditingSubject {
            showDeleteAlert(for: subject)
        }
    }
}
