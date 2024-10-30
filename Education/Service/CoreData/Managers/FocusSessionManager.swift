//
//  FocusSessionManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import CoreData
import UIKit

final class FocusSessionManager: ObjectManager {
    // MARK: - Create

    func createFocusSession(date: Date, totalTime: Int, subjectID: String? = nil) {
        backgroundContext.performAndWait {
            guard let focusSession = NSEntityDescription.insertNewObject(forEntityName: "FocusSession", into: backgroundContext) as? FocusSession else { return }

            focusSession.date = date
            focusSession.totalTime = Int16(totalTime)
            focusSession.subjectID = subjectID
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

    func updateFocusSession(_: FocusSession) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
                print("Failed to update \(error)")
            }
        }
    }

    // MARK: - Fetch

    func fetchFocusSessions(subjectID: String? = nil, allSessions: Bool = false) -> [FocusSession]? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")

        if !allSessions {
            if let subjectID {
                fetchRequest.predicate = NSPredicate(format: "subjectID == %@", subjectID)
            } else {
                fetchRequest.predicate = NSPredicate(format: "subjectID == nil", #keyPath(FocusSession.subjectID))
            }
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
                focusSession = focusSessions.first
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }

        return focusSession
    }
}
