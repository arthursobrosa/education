//
//  TestPageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

protocol TestDelegate: AnyObject {
    func didTapDeleteButton()
    func didTapSaveButton()
    func didChangeComment(_ text: String)
}

extension TestPageViewController: TestDelegate {
    func didTapDeleteButton() {
        viewModel.removeTest()

        coordinator?.dismissAll()
    }

    func didTapSaveButton() {
        let totalQuestions = viewModel.totalQuestions
        let rightQuestions = viewModel.rightQuestions

        guard rightQuestions <= totalQuestions else {
            showWrongQuestionsAlert()
            return
        }

        if totalQuestions == 0 {
            showWrongQuestionsAlert()
            return
        }

        viewModel.saveTest()
        coordinator?.dismiss(animated: true)
    }

    func didChangeComment(_ text: String) {
        viewModel.comment = text
    }
}
