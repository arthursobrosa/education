//
//  TestDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import Foundation

class TestDetailsViewModel {
    // MARK: - Test Manager
    
    private let testManager: TestManager

    // MARK: - Properties
    
    let theme: Theme
    var test: Test

    // MARK: - Initializer
    
    init(theme: Theme, test: Test) {
        self.theme = theme
        self.test = test
        testManager = TestManager()
    }

    // MARK: - Methods
    
    func getDateString(from test: Test) -> String {
        let date = test.unwrappedDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")

        return dateFormatter.string(from: date)
    }

    func getDateFullString() -> String {
        let dayOfTheWeekString = getDayOfTheWeekString(from: test.unwrappedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMM, yyyy")
        let dateString = dateFormatter.string(from: test.unwrappedDate)

        return dayOfTheWeekString + ", " + dateString
    }
    
    private func getDayOfTheWeekString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }

    func getUpdatedTest() {
        let testId = test.unwrappedID

        let updatedTest = testManager.fetchTest(id: testId)

        guard let updatedTest else { return }
        test = updatedTest
    }
    
    func getTestDetailsConfig() -> TestDetailsView.Config {
        let titleText = getDateFullString()
        let notesText = test.unwrappedComment
        let questionsText = "\(test.rightQuestions)/\(test.totalQuestions)"
        let themeTitleText = theme.unwrappedName
        let progress = CGFloat(test.rightQuestions) / CGFloat(test.totalQuestions)
        let dateText = getDateString(from: test)
        let percentageText = "\(Int(CGFloat(test.rightQuestions) / CGFloat(test.totalQuestions) * 100))%"
        
        let config = TestDetailsView.Config(
            titleText: titleText,
            notesText: notesText,
            questionsText: questionsText,
            themeTitleText: themeTitleText,
            progress: progress,
            dateText: dateText,
            percentageText: percentageText
        )
        
        return config
    }
}
