//
//  SubjectDetailsDelegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/11/24.
//

import Foundation

@objc
protocol SubjectDetailsDelegate: AnyObject {
    func editButtonTapped()
    func deleteButtonTapped()
    func dismiss()
}

extension SubjectDetailsViewController: SubjectDetailsDelegate {
    func editButtonTapped() {
        coordinator?.showSubjectCreation(viewModel: viewModel.studyTimeViewModel)
    }
    
    func deleteButtonTapped() {
        showDeleteOtherAlert()
    }
    
    func dismiss() {
        coordinator?.dismiss(animated: true)
    }
}
