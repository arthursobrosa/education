//
//  SubjectCreationViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 22/08/24.
//

import Foundation
import UIKit

protocol SubjectCreationDelegate: AnyObject {
    func textFieldDidChange(newText: String)
    func didTapSaveButton()
    func didTapDeleteButton()
    func didTapCloseButton()
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        subjectName = newText
        if newText.isEmpty {
            subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-off")
        } else {
            subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-selected")
        }
    }

    func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }

    func didTapSaveButton() {
        guard let name = subjectName, !name.isEmpty else {
            showAlert(message: String(localized: "subjectCreationNoName"))
            return
        }
        let cleanName = spaceRemover(string: name)
        if viewModel.currentEditingSubject != nil {
            viewModel.updateSubject(name: cleanName, color: viewModel.selectedSubjectColor.value)
        } else {
            let existingSubjects = viewModel.subjects.value
            if existingSubjects.contains(where: { $0.name?.lowercased() == cleanName.lowercased() }) {
                showAlert(message: String(localized: "subjectCreationUsedName"))
                return
            }

            viewModel.createSubject(name: cleanName, color: viewModel.selectedSubjectColor.value)
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

extension SubjectCreationViewController: ViewCodeProtocol {
    func setupUI() {
        view.addSubview(subjectCreationView)

        NSLayoutConstraint.activate([
            subjectCreationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 366 / 390),
            subjectCreationView.heightAnchor.constraint(equalTo: subjectCreationView.widthAnchor, multiplier: ((self.subjectName != nil) ? 350 : 280) / 366),
            subjectCreationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subjectCreationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        
    }
}
