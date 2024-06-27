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
 
    var items: [ThemeModel] = []
    
    func addNewItem(name: String, id: String) {
            let newItem = ThemeModel(id: id, name: name)
            items.append(newItem)
        }
    
    func fetchItems(completion: @escaping () -> Void) {
        
            let fetchedItems = [
                ThemeModel(id: "1", name: "Matematica"),
                ThemeModel(id: "2", name: "Geografia"),
                ThemeModel(id: "1", name: "Física"),
                ThemeModel(id: "2", name: "Química")
            ]
            
            DispatchQueue.main.async {
                self.items = fetchedItems
                completion()
            }
            
        }
    
    init() {
        
    }
}



