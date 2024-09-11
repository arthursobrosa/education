//
//  ThemeListViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import Foundation

class ThemeListViewModel {
    // MARK: - Themes Handler
    private let themeManager: ThemeManager
    private let testManager: TestManager
    
    // MARK: - Properties
    var themes = Box([Theme]())
    
    var newThemeName = String()
    
    // MARK: - Initializer
    init(themeManager: ThemeManager = ThemeManager(), testManager: TestManager = TestManager()) {
        self.themeManager = themeManager
        self.testManager = testManager
    }
    
    // MARK: - Methods
    func addTheme() {
        self.themeManager.createTheme(name: self.newThemeName)
        self.fetchThemes()
    }
    
    func removeTheme(theme: Theme) {
        self.themeManager.deleteTheme(theme)
        self.fetchThemes()
    }
    
    func fetchThemes() {
        if let themes = self.themeManager.fetchThemes() {
            self.themes.value = themes
        }
    }
    
    func getMostRecentTest(from theme: Theme) -> Test? {
        guard let tests = self.testManager.fetchTests(themeID: theme.unwrappedID),
              !tests.isEmpty else { return nil }
        
        let dates = tests.compactMap { $0.unwrappedDate }
        
        guard let mostRecentDate = dates.max(),
              let testIndex = tests.firstIndex(where: { $0.unwrappedDate == mostRecentDate }) else { return nil }
        
        return tests[testIndex]
    }
    
    func getThemeDescription(with test: Test) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMM")
        
        let dateString = dateFormatter.string(from: test.unwrappedDate).capitalized
        
        return String(localized: "last") + ": " + "\(dateString) | \(test.unwrappedRightQuestions)/\(test.unwrappedTotalQuestions)"
    }
}
