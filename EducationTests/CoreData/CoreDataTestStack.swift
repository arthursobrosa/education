//
//  CoreDataTestStack.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import CoreData
@testable import Education
import XCTest

/*
 This is the CoreDataManager used by tests. It saves nothing to disk. All in-memory.

 When setting up tests authors can choose the queues they would like to operate on.
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing

 Note: This can't be a shared singleton. Else tests would collide with each other.
 */

struct CoreDataTestStack {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "DataBase")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType

        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }

        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator

        backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.parent = mainContext
    }
}
