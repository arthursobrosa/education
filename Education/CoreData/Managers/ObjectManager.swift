//
//  ObjectManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import Foundation
import CoreData

class ObjectManager {
    // MARK: - Contexts
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
}
