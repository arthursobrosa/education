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
    
    init(testManager: TestManager = TestManager(), theme: Theme) {
        self.testManager = testManager
        self.theme = theme
    }
    
    func addNewTest(date: Date, rightQuestions: Int, totalQuestions: Int) {
        self.testManager.createTest(themeID: self.theme.unwrappedID, date: date, rightQuestions: rightQuestions, totalQuestions: totalQuestions)
    }
    
    func removeTest(_ test: Test) {
        self.testManager.deleteTest(test)
    }
}
