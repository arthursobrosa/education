//
//  ThemePageViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation
import Charts

class ThemePageViewModel: ObservableObject {
    // MARK: - Tests Handler
    private let themeManager: ThemeManager
    private let testManager: TestManager
    
    // MARK: - Properties
    var tests = Box([Test]())
    
    var theme: Theme
    
    var limits: [Int] = [7, 15, 30]
    @Published var selectedLimit: Int = 7 {
        didSet {
            self.getLimitedItems()
        }
    }
    @Published var limitedItems = [BarMark]()
    
    // MARK: - Initializer
    init(themeManager: ThemeManager = ThemeManager(), testManager: TestManager = TestManager(), theme: Theme) {
        self.themeManager = themeManager
        self.testManager = testManager
        self.theme = theme
    }
    
    // MARK: - Methods
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
            self.getLimitedItems()
        }
    }
    
    func getLimitedItems() {
        var limitedItems: [BarMark] = []
        let itemsToShow = self.tests.value.sorted{$0.date! < $1.date!}.suffix(self.selectedLimit)
        
        for (index, item) in itemsToShow.enumerated() {
            let bar = BarMark(
                x: .value("Index", index),
                y: .value("Test", (Double(item.rightQuestions) / Double(item.totalQuestions)))
            )
            
            limitedItems.append(bar)
        }
        
        while (limitedItems.count < self.selectedLimit) {
            let additionalBar = BarMark(
                x: .value("Index", limitedItems.count),
                y: .value("Test", 0)
            )
            
            limitedItems.append(additionalBar)
        }
        
        self.limitedItems = limitedItems
    }
    
    func removeTheme() {
        self.themeManager.deleteTheme(self.theme)
    }
}
