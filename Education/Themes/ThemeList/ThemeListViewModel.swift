//
//  ThemeListViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import Foundation

class ThemeListViewModel {
    let themeManager: ThemeManager
    
    init(themeManager: ThemeManager = ThemeManager(mainContext: CoreDataStack.shared.mainContext, backgroundContext: CoreDataStack.shared.backgroundContext)) {
        self.themeManager = themeManager
    }
    
    var themes = Box([Theme]())
    
    func addNewItem(name: String) {
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
