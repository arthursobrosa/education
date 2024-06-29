//
//  ThemePageViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation

class ThemePageViewModel {
    let testManager: TestManager
    
    init(testManager: TestManager = TestManager(mainContext: CoreDataStack.shared.mainContext, backgroundContext: CoreDataStack.shared.backgroundContext), theme: Theme) {
        self.testManager = testManager
        self.theme = theme
    }
    
    var tests = Box([Test]())
    
    var theme: Theme
    
    func addNewTest(date: Date, rightQuestions: Int, totalQuestions: Int) {
        self.testManager.createTest(themeID: self.theme.unwrappedID, date: date, rightQuestions: rightQuestions, totalQuestions: totalQuestions)
        self.fetchTests()
    }
    
    func removeTest(_ test: Test) {
        self.testManager.deleteTest(test)
        self.fetchTests()
    }
    
    func fetchTests() {
        if let tests = self.testManager.fetchTests(themeID: self.theme.unwrappedID) {
            self.tests.value = tests
        }
    }
}
