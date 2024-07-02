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
            if let schedules = self.scheduleManager.fetchSchedules(subjectID: subject.unwrappedID) {
                schedules.forEach { schedule in
                    self.scheduleManager.deleteSchedule(schedule)
                }
            }
            
            if let subjectInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(subjectInContext)
                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
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
