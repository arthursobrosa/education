//
//  FocusSessionManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit
import CoreData

class FocusSessionManager {
    // MARK: - Contexts
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    func createFocusSession(date: Date, totalTime: Int, scheduleID: String? = nil) {
        backgroundContext.performAndWait {
            guard let focusSession = NSEntityDescription.insertNewObject(forEntityName: "FocusSession", into: backgroundContext) as? FocusSession else { return }
            
            focusSession.date = date
            focusSession.totalTime = Int16(totalTime)
            focusSession.scheduleID = scheduleID
            focusSession.id = UUID().uuidString
            
            try? backgroundContext.save()
            CoreDataStack.shared.saveMainContext()
        }
    }
    
    // MARK: - Deletion
    func deleteFocusSession(_ focusSession: FocusSession) {
        let objectID = focusSession.objectID
        backgroundContext.performAndWait {
            if let focusSessionInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(focusSessionInContext)
                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            }
        }
    }
    
    // MARK: - Update
    func updateFocusSession(_ focusSession: FocusSession) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to update \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    func fetchFocusSessions(scheduleID: String?) -> [FocusSession]? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")
        
        if let scheduleID = scheduleID {
            fetchRequest.predicate = NSPredicate(format: "scheduleID == %@", scheduleID)
        } else {
            fetchRequest.predicate = NSPredicate(format: "scheduleID == nil", #keyPath(FocusSession.scheduleID))
        }
        
        var focusSessions: [FocusSession]?
        
        mainContext.performAndWait {
            do {
                focusSessions = try mainContext.fetch(fetchRequest)
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return focusSessions
    }
    
    func fetchFocusSession(withID id: String) -> FocusSession? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        var focusSession: FocusSession?
        
        mainContext.performAndWait {
            do {
                let focusSessions = try mainContext.fetch(fetchRequest)
                focusSession =  focusSessions.first
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return focusSession
    }
}
