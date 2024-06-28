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
    
    /*
     Note: All fetches should always be done on mainContext. Updates, creates, deletes can be background.
     Contexts are passed in so they can be overriden via unit testing.
    */
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    func createTheme(name: String) {
        backgroundContext.performAndWait {
            guard let theme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: backgroundContext) as? Theme else { return }
            
            theme.name = name
            theme.id = UUID().uuidString
            
            try? backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    func deleteTheme(_ theme: Theme) {
        let objectID = theme.objectID
        backgroundContext.performAndWait {
            // TODO: delete tests
            
            if let themeInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(themeInContext)
                try? backgroundContext.save()
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
