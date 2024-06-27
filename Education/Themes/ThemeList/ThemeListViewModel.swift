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
    var onFetchThemes: (([Theme]) -> Void)?
    
    var items: [Theme] = []
    
    func addNewItem(name: String) {
        CoreDataManager.shared.createTheme(name: name)
        self.fetchItems()
    }
    
    func fetchItems() {
        if let themes = CoreDataManager.shared.fetchThemes() {
            self.items = themes
            self.onFetchThemes?(themes)
        }
    }
}



