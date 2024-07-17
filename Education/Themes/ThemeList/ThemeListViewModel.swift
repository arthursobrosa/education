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
    
    // MARK: - Properties
    var themes = Box([Theme]())
    
    // MARK: - Initializer
    init(themeManager: ThemeManager = ThemeManager()) {
        self.themeManager = themeManager
    }
    
    // MARK: - Methods
    func addTheme(name: String) {
        self.themeManager.createTheme(name: name)
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
}
