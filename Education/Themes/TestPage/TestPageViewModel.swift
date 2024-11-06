//
//  TestPageViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import Foundation

class TestPageViewModel {
    private let testManager: TestManager

    private let theme: Theme
    let test: Test?

    var date = Date()
    var totalQuestions = Int()
    var rightQuestions = Int()
    var comment = String()

    init(testManager: TestManager = TestManager(), theme: Theme, test: Test?) {
        self.testManager = testManager
        self.theme = theme
        self.test = test

        if let test {
            date = test.unwrappedDate
            totalQuestions = test.unwrappedTotalQuestions
            rightQuestions = test.unwrappedRightQuestions
            comment = test.unwrappedComment
        }
    }

    func saveTest() {
        if let test {
            updateTest(test)

            return
        }

        addNewTest()
    }

    private func updateTest(_ test: Test) {
        test.date = date
        test.totalQuestions = Int64(totalQuestions)
        test.rightQuestions = Int64(rightQuestions)
        test.comment = comment

        testManager.updateTest(test)
    }

    private func addNewTest() {
        testManager.createTest(
            themeID: theme.unwrappedID,
            date: date,
            rightQuestions: rightQuestions,
            totalQuestions: totalQuestions,
            comment: comment
        )
    }

    func removeTest() {
        guard let test else { return }

        testManager.deleteTest(test)
    }

    func getTitle() -> String {
        if let _ = test {
            return String(localized: "editTest")
        }

        return String(localized: "newTest")
    }
}
