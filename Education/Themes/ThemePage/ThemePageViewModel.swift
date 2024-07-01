//
//  ThemePageViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation

class ThemePageViewModel {
    let testManager: TestManager
    
    init(testManager: TestManager = TestManager(mainContext: CoreDataStack.shared.mainContext, backgroundContext: CoreDataStack.shared.backgroundContext), themeID: String) {
        self.testManager = testManager
        self.themeID = themeID
    }
    
    var tests = Box([Test]())
    
    var themeID: String
    
    func addNewTest(date: Date, rightQuestions: Int, totalQuestions: Int) {
        self.testManager.createTest(themeID: self.themeID, date: date, rightQuestions: rightQuestions, totalQuestions: totalQuestions)
        self.fetchTests()
    }
    
    func removeTest(_ test: Test) {
        self.testManager.deleteTest(test)
        self.fetchTests()
    }
    
    func fetchTests() {
        if let tests = self.testManager.fetchTests(themeID: self.themeID) {
            self.tests.value = tests
        }
    }
}
