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
        self.viewModel.removeTest()
        
        self.coordinator?.dismissAll()
    }
    
    func didTapSaveButton() {
        let totalQuestions = self.viewModel.totalQuestions
        let rightQuestions = self.viewModel.rightQuestions
        
        guard rightQuestions <= totalQuestions else {
            self.showWrongQuestionsAlert()
            return
        }
        
        if totalQuestions == 0 {
            self.showWrongQuestionsAlert()
            return
        }
        
        self.viewModel.saveTest()
        self.coordinator?.dismiss(animated: true)
    }
    
    func didChangeComment(_ text: String) {
        self.viewModel.comment = text
    }
}
