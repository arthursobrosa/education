//
//  ThemeCreationViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/09/24.
//

import Foundation

class ThemeCreationViewModel {
    private let themeManager: ThemeManager

    var theme: Theme?
    var currentThemeName: String

    init(themeManager: ThemeManager = ThemeManager(), theme: Theme?) {
        self.themeManager = themeManager

        self.theme = theme

        if let theme {
            currentThemeName = theme.unwrappedName
        } else {
            currentThemeName = String()
        }
    }

    func saveTheme() {
        if let theme {
            updateTheme(theme)
        } else {
            addTheme()
        }
    }

    private func updateTheme(_ theme: Theme) {
        if let editingTheme = themeManager.fetchTheme(withName: theme.unwrappedName) {
            editingTheme.name = currentThemeName

            themeManager.updateTheme(editingTheme)
        }
    }

    private func addTheme() {
        themeManager.createTheme(name: currentThemeName)
    }
}
