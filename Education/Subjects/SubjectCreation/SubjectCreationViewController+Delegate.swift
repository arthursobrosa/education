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
}

extension SubjectCreationViewController: SubjectCreationDelegate {
    func textFieldDidChange(newText: String) {
        self.subjectName = newText
        if newText != "" {
            self.subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-selected")
        }else{
            self.subjectCreationView.saveButton.backgroundColor = UIColor(named: "button-off")
        }
    }
    
    func spaceRemover(string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
    
    func didTapSaveButton() {
        guard let name = self.subjectName, !name.isEmpty else {
            showAlert(message: String(localized: "subjectCreationNoName"))
            return
        }
        let cleanName = spaceRemover(string: name)
        if self.viewModel.currentEditingSubject != nil {
            self.viewModel.updateSubject(name: cleanName, color: self.viewModel.selectedSubjectColor.value)
        } else {
            let existingSubjects = viewModel.subjects.value
            if existingSubjects.contains(where: { $0.name?.lowercased() == cleanName.lowercased() }) {
                self.showAlert(message: String(localized: "subjectCreationUsedName"))
                return
            }
            
            self.viewModel.createSubject(name: cleanName, color: self.viewModel.selectedSubjectColor.value)
        }
        
        self.coordinator?.dismiss(animated: true)
    }
    
    func didTapDeleteButton() {
        self.showDeleteAlert(for: self.viewModel.currentEditingSubject!)
    }
}
