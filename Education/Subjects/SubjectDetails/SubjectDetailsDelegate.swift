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
    func didCancel()
    func didDelete()
    func dismiss()
}

extension SubjectDetailsViewController: SubjectDetailsDelegate {
    func editButtonTapped() {
        coordinator?.showSubjectCreation(viewModel: viewModel.studyTimeViewModel)
    }
    
    func deleteButtonTapped() {
        let alertCase: AlertCase = .deletingOtherFocusSession
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: subjectDetailsView)
        subjectDetailsView.deleteOtherAlertView.config = alertConfig
        subjectDetailsView.deleteOtherAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        subjectDetailsView.deleteOtherAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        subjectDetailsView.changeAlertVisibility(isShowing: true)
    }
    
    func didCancel() {
        subjectDetailsView.changeAlertVisibility(isShowing: false)
    }
    
    func didDelete() {
        viewModel.deleteOtherSessions()
        viewModel.fetchFocusSessions()
        reloadTable()
        coordinator?.dismiss(animated: true)
    }
    
    func dismiss() {
        coordinator?.dismiss(animated: true)
    }
}
