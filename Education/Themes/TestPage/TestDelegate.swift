//
//  TestPageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

@objc
protocol TestDelegate: AnyObject {
    func didTapCancelButton()
    func didTapSaveButton()
    func didChangeComment(_ text: String)
    func didTapDeleteButton()
    func didCancelDeletion()
    func didDelete()
}

extension TestPageViewController: TestDelegate {
    func didTapCancelButton() {
        coordinator?.dismiss(animated: true)
    }
    
    func didTapSaveButton() {
        let totalQuestions = viewModel.totalQuestions
        let rightQuestions = viewModel.rightQuestions
        
        if viewModel.theme == nil {
            if viewModel.isThemeNameEmpty() {
                showInvalidNameAlert()
                return
            }
        }
        
        if rightQuestions > totalQuestions || totalQuestions == 0 {
            showWrongQuestionsAlert()
            return
        }

        viewModel.saveTest()
        coordinator?.dismiss(animated: true)
    }

    func didChangeComment(_ text: String) {
        viewModel.comment = text
    }
    
    func didTapDeleteButton() {
        let alertCase: AlertCase = .deletingTest
        let alertConfig = AlertView.AlertConfig.getAlertConfig(with: alertCase, superview: testPageView)
        testPageView.deleteAlertView.config = alertConfig
        testPageView.deleteAlertView.setPrimaryButtonTarget(self, action: alertCase.primaryButtonAction)
        testPageView.deleteAlertView.setSecondaryButtonTarget(self, action: alertCase.secondaryButtonAction)
        testPageView.changeAlertVisibility(isShowing: true)
    }
    
    func didCancelDeletion() {
        testPageView.changeAlertVisibility(isShowing: false)
    }
    
    func didDelete() {
        viewModel.removeTest()
        coordinator?.dismissAll()
    }
}
