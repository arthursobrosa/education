//
//  SubjectManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit
import CoreData

class SubjectManager {
    // MARK: - Contexts
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    /*
     Note: All fetches should always be done on mainContext. Updates, creates, deletes can be background.
     Contexts are passed in so they can be overriden via unit testing.
    */
    
    lazy var scheduleManager = ScheduleManager(mainContext: self.mainContext, backgroundContext: self.backgroundContext)
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }
    
    // MARK: - Create
    func createSubject(name: String) {
        backgroundContext.performAndWait {
            guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: backgroundContext) as? Subject else { return }
            
            subject.name = name
            subject.id = UUID().uuidString
            
            try? backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    func deleteSubject(_ subject: Subject) {
        let objectID = subject.objectID
        backgroundContext.performAndWait {
            if let schedules = self.scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) {
                schedules.forEach { schedule in
                    self.scheduleManager.deleteSchedule(schedule)
                }
            }
            
            if let subjectInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(subjectInContext)
                try? backgroundContext.save()
            }
            
        }
    }
    
    // MARK: - Update
    func updateSubject(_ subject: Subject) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to update \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    
    /*
     Rule: Managed object retrieved from a context are bound to the same queue that the context is bound to.
     
     So if we want the results of our fetches to be used in the UI, we should do those fetching from the main UI context.
    */
    
    func fetchSubject(withName name: String) -> Subject? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        var subject: Subject?
        
        mainContext.performAndWait {
            do {
                let subjects = try mainContext.fetch(fetchRequest)
                subject = subjects.first
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        return subject
    }
    
    func fetchSubjects() -> [Subject]? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        
        var subjects: [Subject]?
        
        mainContext.performAndWait {
            do {
                subjects = try mainContext.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        return subjects
    }
}
