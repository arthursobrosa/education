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

    func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }

    func didTapSaveButton() {
        guard let name = subjectName else { return }
        
        let cleanName = spaceRemover(string: name)
        if viewModel.currentEditingSubject != nil {
            viewModel.updateSubject(name: cleanName, color: viewModel.selectedSubjectColor.value)
        } else {
            let existingSubjects = viewModel.subjects.value
            if existingSubjects.contains(where: { $0.name?.lowercased() == cleanName.lowercased() }) {
                showAlert(message: String(localized: "subjectCreationUsedName"))
                return
            }

            viewModel.createSubject(name: cleanName)
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
