//
//  SubjectCreationViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 22/08/24.
//

import Foundation

protocol SubjectCreationDelegate: AnyObject {
    func textFieldDidChange(newText: String)
    func didTapSaveButton()
    func didTapDeleteButton()
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        self.subjectName = newText
    }
    
    func didTapSaveButton() {
        guard let name = self.subjectName, !name.isEmpty else {
            showAlert(message: String(localized: "subjectCreationNoName"))
            return
        }
        
        if self.viewModel.currentEditingSubject != nil {
            self.viewModel.updateSubject(name: name, color: self.viewModel.selectedSubjectColor.value)
        } else {
            let existingSubjects = viewModel.subjects.value
            if existingSubjects.contains(where: { $0.name?.lowercased() == name.lowercased() }) {
                self.showAlert(message: String(localized: "subjectCreationUsedName"))
                return
            }
            
            self.viewModel.createSubject(name: name, color: self.viewModel.selectedSubjectColor.value)
        }
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func didTapDeleteButton() {
        self.showDeleteAlert(for: self.viewModel.currentEditingSubject!)
    }
}
