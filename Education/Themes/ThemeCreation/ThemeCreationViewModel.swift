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
            self.currentThemeName = theme.unwrappedName
        } else {
            self.currentThemeName = String()
        }
    }
    
    func saveTheme() {
        if let theme {
            self.updateTheme(theme)
        } else {
            self.addTheme()
        }
    }
    
    private func updateTheme(_ theme: Theme) {
        if let editingTheme = self.themeManager.fetchTheme(withName: theme.unwrappedName) {
            editingTheme.name = self.currentThemeName
            
            self.themeManager.updateTheme(editingTheme)
        }
    }
    
    private func addTheme() {
        self.themeManager.createTheme(name: self.currentThemeName)
    }
}
