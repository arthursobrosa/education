//
//  TestPageViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import Foundation

class TestPageViewModel {
    // MARK: - Test and Theme Managers
    
    private let testManager: TestManager
    private let themeManager: ThemeManager

    // MARK: - Properties
    
    var theme: Theme?
    let test: Test?

    var date = Date()
    var totalQuestions = Int()
    var rightQuestions = Int()
    var comment = String()
    lazy var themeName: String? = theme?.unwrappedName

    // MARK: - Initializer
    
    init(testManager: TestManager = TestManager(), themeManager: ThemeManager = ThemeManager(), theme: Theme?, test: Test?) {
        self.testManager = testManager
        self.themeManager = themeManager
        self.theme = theme
        self.test = test

        if let test {
            date = test.unwrappedDate
            totalQuestions = test.unwrappedTotalQuestions
            rightQuestions = test.unwrappedRightQuestions
            comment = test.unwrappedComment
        }
    }

    // MARK: - Methods
    
    func isThemeNameEmpty() -> Bool {
        guard let themeName else { return true }
        
        return themeName.isEmpty
    }
    
    func saveTest() {
        guard let themeName else { return }
        
        if theme == nil {
            createTheme(name: themeName)
            addNewTest()
        } else {
            if let test {
                updateTest(test)

                return
            }
            
            addNewTest()
        }
    }

    private func updateTest(_ test: Test) {
        test.date = date
        test.totalQuestions = Int64(totalQuestions)
        test.rightQuestions = Int64(rightQuestions)
        test.comment = comment

        testManager.updateTest(test)
    }

    private func addNewTest() {
        guard let newTheme = theme else { return }
        
        testManager.createTest(
            themeID: newTheme.unwrappedID,
            date: date,
            rightQuestions: rightQuestions,
            totalQuestions: totalQuestions,
            comment: comment
        )
    }
    
    func createTheme(name: String) {
        themeManager.createTheme(name: name)
        theme = themeManager.fetchTheme(withName: name)
    }

    func removeTest() {
        guard let test else { return }

        testManager.deleteTest(test)
    }

    func getTitle() -> String {
        if test != nil {
            String(localized: "editResult")
        } else {
            String(localized: "newResult")
        }
    }
}
