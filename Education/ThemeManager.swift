//
//  ThemeManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit
import CoreData

class ThemeManager {
    // MARK: - Contexts
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    lazy var testManager = TestManager(mainContext: self.mainContext, backgroundContext: self.mainContext)
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    func createTheme(name: String) {
        backgroundContext.performAndWait {
            guard let theme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: self.backgroundContext) as? Theme else { return }
            
            theme.name = name
            theme.id = UUID().uuidString
            
            try? backgroundContext.save()
            CoreDataStack.shared.saveMainContext()
        }
    }
    
    // MARK: - Deletion
    func deleteTheme(_ theme: Theme) {
        let objectID = theme.objectID
        backgroundContext.performAndWait {
            if let tests = self.testManager.fetchTests(themeID: theme.unwrappedID) {
                tests.forEach { test in
                    self.testManager.deleteTest(test)
                }
            }
            
            if let themeInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(themeInContext)
                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            }
        }
    }
    
    // MARK: - Update
    func updateTheme(_ theme: Theme) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to update \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    func fetchTheme(withName name: String) -> Theme? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var theme: Theme?
        
        mainContext.performAndWait {
            do {
                let themes = try mainContext.fetch(fetchRequest)
                theme =  themes.first
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return theme
    }
    
    func fetchThemes() -> [Theme]? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        
        var themes: [Theme]?
        
        mainContext.performAndWait {
            do {
                themes = try mainContext.fetch(fetchRequest)
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return themes
    }
}
