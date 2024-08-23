//
//  SubjectListViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 21/08/24.
//

import Foundation

protocol SubjectListDelegate: AnyObject {
    func addButtonTapped()
}

extension SubjectListViewController: SubjectListDelegate {
    func addButtonTapped() {
        self.viewModel.currentEditingSubject = nil
        self.viewModel.selectedSubjectColor.value = self.viewModel.subjectColors[0]
        self.coordinator?.showSubjectCreation(viewModel: viewModel)
    }
}
