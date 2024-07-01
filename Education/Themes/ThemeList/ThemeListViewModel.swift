//
//  ThemeListViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import Foundation

struct ThemeModel {
    let id: String
    let name: String
}

class ThemeListViewModel {
    var onFetchThemes: (() -> Void)?
    
    var items: [Theme] = []
    
    func addNewItem(name: String) {
        CoreDataManager.shared.createTheme(name: name)
        self.fetchItems()
    }
    
    func removeItem(id: String) {
        guard let theme = CoreDataManager.shared.fetchTheme(id) else {
            print("Error: Theme not found.")
            return
        }
        
        CoreDataManager.shared.deleteTheme(theme)
        self.fetchItems()
    }
    
    func fetchItems() {
        if let themes = CoreDataManager.shared.fetchThemes() {
            self.items = themes
            self.onFetchThemes?()
        }
    }
}



