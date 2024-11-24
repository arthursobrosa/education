//
//  ThemeEditionViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/09/24.
//

import Foundation

class ThemeEditionViewModel {
    // MARK: - Theme Manager
    
    private let themeManager: ThemeManager

    // MARK: - Properties
    
    var theme: Theme
    var currentThemeName: String

    // MARK: - Initializer
    
    init(themeManager: ThemeManager = ThemeManager(), theme: Theme) {
        self.themeManager = themeManager

        self.theme = theme
        currentThemeName = theme.unwrappedName
    }

    // MARK: - Methods
    
    func updateTheme() {
        if let editingTheme = themeManager.fetchTheme(withName: theme.unwrappedName) {
            editingTheme.name = currentThemeName

            themeManager.updateTheme(editingTheme)
        }
    }
}
