//
//  ScheduleManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit
import CoreData

class ScheduleManager {
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
    func createSchedule(subjectID: String, dayOfTheWeek: Int, startTime: Date, endTime: Date) {
        backgroundContext.performAndWait {
            guard let schedule = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: backgroundContext) as? Schedule else { return }
            
            schedule.subjectID = subjectID
            schedule.dayOfTheWeek = Int16(dayOfTheWeek)
            schedule.startTime = startTime
            schedule.endTime = endTime
            schedule.id = UUID().uuidString
            
            try? backgroundContext.save()
        }
    }
    
    // MARK: - Deletion
    func deleteSchedule(_ schedule: Schedule) {
        let objectID = schedule.objectID
        backgroundContext.performAndWait {
            // TODO: delete focus sessions
            
            if let scheduleInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(scheduleInContext)
                try? backgroundContext.save()
            }
        }
    }
    
    // MARK: - Update
    func updateSchedule(_ schedule: Schedule) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch let error {
                print("Failed to update \(error)")
            }
        }
    }
    
    // MARK: - Fetch
    func fetchSchedule(from id: String) -> Schedule? {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        var schedule: Schedule?
        
        mainContext.performAndWait {
            do {
                let schedules = try mainContext.fetch(fetchRequest)
                schedule = schedules.first
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return schedule
    }
    
    func fetchSchedules(subjectID: String? = nil, dayOfTheWeek: Int? = nil) -> [Schedule]? {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        
        if let subjectID = subjectID {
            fetchRequest.predicate = NSPredicate(format: "subjectID == %@", subjectID)
        } else if let dayOfTheWeek = dayOfTheWeek {
            fetchRequest.predicate = NSPredicate(format: "dayOfTheWeek == %@", dayOfTheWeek)
        } else {
            print("Found nil on arguments")
            return nil
        }
        
        var schedules: [Schedule]?
        
        mainContext.performAndWait {
            do {
                schedules = try mainContext.fetch(fetchRequest)
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }
        
        return schedules
    }
}
