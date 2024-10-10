//
//  ThemePageViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation

class ThemePageViewModel: ObservableObject {
    // MARK: - Tests Handler
    private let themeManager: ThemeManager
    private let testManager: TestManager
    
    // MARK: - Properties
    var tests = Box([Test]())
    
    var theme: Theme
    
    var limits: [Int] = [10, 15, 20]
    var selectedLimit: Int = 10
    
    // MARK: - Initializer
    init(themeManager: ThemeManager = ThemeManager(), testManager: TestManager = TestManager(), theme: Theme) {
        self.themeManager = themeManager
        self.testManager = testManager
        self.theme = theme
    }
    
    // MARK: - Methods
    func fetchTests() {
        if let tests = self.testManager.fetchTests(themeID: self.theme.unwrappedID) {
            self.tests.value = tests.sorted { $0.unwrappedDate > $1.unwrappedDate }
        }
    }
    
    func getLimitedItems() -> [TestForChart] {
        var testsForChart = [TestForChart]()
        
        for test in self.tests.value {
            let percentage = Double(test.unwrappedRightQuestions) / Double(test.unwrappedTotalQuestions)
            
            let testForChart = TestForChart(percentage: percentage, date: test.unwrappedDate)
            
            testsForChart.append(testForChart)
        }
        
        return testsForChart
    }
    
    func hasComment(test: Test) -> Bool{
         var hasComment = false
         if (test.comment != nil) {
             if (test.unwrappedComment != "") {
                 hasComment = true
             }
         }
         return hasComment
     }
    
    func getDateString(from test: Test) -> String {
        let date = test.unwrappedDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")

        return dateFormatter.string(from: date)
    }
    
    func getQuestionsString(from test: Test) -> String {
        return String(test.unwrappedRightQuestions) + "/" + String(test.unwrappedTotalQuestions)
    }
}

class TestForChart {
    var percentage: Double
    var date: Date
    
    init(percentage: Double, date: Date) {
        self.percentage = percentage
        self.date = date
    }
}
