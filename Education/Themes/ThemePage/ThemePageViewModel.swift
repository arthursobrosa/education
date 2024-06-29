//
//  ThemePageViewModel.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation

class ThemePageViewModel {
    var onFetchThemes: (() -> Void)?
    var onFetchInfo: (() -> Void)?
    
    private var theme: Theme? {
            didSet {
                // Notify view controller that theme is fetched
                self.onFetchInfo?()
                print("Busquei")
            }
        }
    
    var themeId: String
    
    var items: [Test] = []
    
    init(themeId: String) {
            self.themeId = themeId
        }
    
    func addNewItem() {
        CoreDataManager.shared.createTest(themeID: self.themeId, date: Date.now, rightQuestions: 25, totalQuestions: 30)
        self.fetchItems()
    }
    
    func removeItem(id: String) {
//        guard let theme = CoreDataManager.shared.fetchTheme(id) else {
//            print("Error: Theme not found.")
//            return
//        }
//        
//        CoreDataManager.shared.deleteTheme(theme)
//        self.fetchItems()
    }
    
    func fetchItems() {
        if let themes = CoreDataManager.shared.fetchTests(from: self.themeId) {
            self.items = themes
            self.onFetchThemes?()
        }
    }
    
    func fetchInfo() {
        if let info = CoreDataManager.shared.fetchTheme(self.themeId) {
            self.theme = info
            self.onFetchInfo?()
        }
        
    }
    
    func getFetchedTheme() -> Theme? {
            return self.theme
        }
}




