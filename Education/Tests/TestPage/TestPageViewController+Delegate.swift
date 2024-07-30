//
//  TestPageViewController+Delegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import Foundation

protocol TestDelegate: AnyObject {
    func addTestTapped(totalQuestions: Int, rightQuestions: Int, date: Date)
}

extension TestPageViewController: TestDelegate {
    func addTestTapped(totalQuestions: Int, rightQuestions: Int, date: Date) {
        guard rightQuestions <= totalQuestions else {
            self.showWrongQuestionsAlert()
            return
        }
        
        if totalQuestions == 0 {
            self.showWrongQuestionsAlert()
            return
        }
        
        self.viewModel.addNewTest(
            date: date,
            rightQuestions: rightQuestions,
            totalQuestions: totalQuestions
        )
        
        self.dismiss(animated: true)
    }
}
