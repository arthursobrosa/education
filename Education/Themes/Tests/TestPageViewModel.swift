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
            self.date = test.unwrappedDate
            self.totalQuestions = test.unwrappedTotalQuestions
            self.rightQuestions = test.unwrappedRightQuestions
            self.comment = test.unwrappedComment
        }
    }
    
    func saveTest() {
        if let test {
            self.updateTest(test)
            
            return
        }
        
        self.addNewTest()
    }
    
    private func updateTest(_ test: Test) {
        test.date = self.date
        test.totalQuestions = Int64(self.totalQuestions)
        test.rightQuestions = Int64(self.rightQuestions)
        test.comment = self.comment
        
        self.testManager.updateTest(test)
    }
    
    private func addNewTest() {
        self.testManager.createTest(
            themeID: self.theme.unwrappedID,
            date: self.date,
            rightQuestions: self.rightQuestions,
            totalQuestions: self.totalQuestions,
            comment: self.comment
        )
    }
    
    func removeTest() {
        guard let test else { return }
        
        self.testManager.deleteTest(test)
    }
    
    func getTitle() -> String {
        if let _ = self.test {
            return String(localized: "editTest")
        }
        
        return String(localized: "newTest")
    }
}
