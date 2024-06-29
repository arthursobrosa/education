//
//  CoreDataStack.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import Foundation
import CoreData

/*
 This is the CoreDataManager used by the app. It saves changes to disk.

 Managers can do operations via the:
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing

 */

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentCloudKitContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentCloudKitContainer(name: "DataBase")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = persistentContainer.viewContext
        
        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = self.mainContext
    }
}
