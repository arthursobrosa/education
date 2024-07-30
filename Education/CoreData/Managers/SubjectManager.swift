//
//  SubjectManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit
import CoreData

final class SubjectManager: ObjectManager {
    lazy var scheduleManager = ScheduleManager()
    
    // MARK: - Create
    func createSubject(name: String) {
        backgroundContext.performAndWait {
            guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: backgroundContext) as? Subject else { return }
            
            subject.name = name
            subject.id = UUID().uuidString
            
            try? backgroundContext.save()
            CoreDataStack.shared.saveMainContext()
        }
    }
    
    // MARK: - Deletion
    func deleteSubject(_ subject: Subject) {
        let objectID = subject.objectID
        backgroundContext.performAndWait {
            guard let schedules = self.scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) else { return }
            
            schedules.forEach { schedule in
                self.scheduleManager.deleteSchedule(schedule)
            }
            
            do {
                let subjectInContext = try backgroundContext.existingObject(with: objectID)
                backgroundContext.delete(subjectInContext)
                
                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            } catch let error {
                print("Failed to get object \(error)")
            }
        }
    }
    
    // MARK: - Update
    func updateSubject(_ subject: Subject) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            } catch let error {
                print("Failed to update \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    func fetchSubject(withID id: String? = nil, withName name: String? = nil) -> Subject? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        } else if let name = name {
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        } else {
            print("Found nil on arguments")
            return nil
        }
        
        fetchRequest.fetchLimit = 1
        
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
