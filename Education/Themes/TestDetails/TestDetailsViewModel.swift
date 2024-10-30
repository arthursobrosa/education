//
//  TestDetailsViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import Foundation

class TestDetailsViewModel {
    private let testManager: TestManager

    let theme: Theme
    var test: Test

    init(theme: Theme, test: Test) {
        self.theme = theme
        self.test = test
        testManager = TestManager()
    }

    func getDateString(from test: Test) -> String {
        let date = test.unwrappedDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")

        return dateFormatter.string(from: date)
    }

    func getDateFullString(from test: Test) -> String {
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
}
