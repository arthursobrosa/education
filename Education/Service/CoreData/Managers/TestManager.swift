//
//  TestManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import CoreData
import UIKit

final class TestManager: ObjectManager {
    // MARK: - Create

    func createTest(themeID: String, date: Date, rightQuestions: Int, totalQuestions: Int, comment: String? = "") {
        backgroundContext.performAndWait {
            guard let test = NSEntityDescription.insertNewObject(forEntityName: "Test", into: backgroundContext) as? Test else { return }

            test.themeID = themeID
            test.date = date
            test.rightQuestions = Int64(rightQuestions)
            test.totalQuestions = Int64(totalQuestions)
            test.comment = comment
            test.id = UUID().uuidString

            try? backgroundContext.save()
            CoreDataStack.shared.saveMainContext()
        }
    }

    // MARK: - Deletion

    func deleteTest(_ test: Test) {
        let objectID = test.objectID
        backgroundContext.performAndWait {
            if let testInContext = try? backgroundContext.existingObject(with: objectID) {
                backgroundContext.delete(testInContext)
                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            }
        }
    }

    // MARK: - Update

    func updateTest(_: Test) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
                print("Failed to update \(error)")
            }
        }
    }

    // MARK: - Fetch

    func fetchTests(themeID: String) -> [Test]? {
        let fetchRequest = NSFetchRequest<Test>(entityName: "Test")
        fetchRequest.predicate = NSPredicate(format: "themeID == %@", themeID)

        var tests: [Test]?

        mainContext.performAndWait {
            do {
                tests = try mainContext.fetch(fetchRequest)
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }

        return tests
    }

    func fetchTest(id: String) -> Test? {
        let fetchRequest = NSFetchRequest<Test>(entityName: "Test")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        var test: Test?

        mainContext.performAndWait {
            do {
                let tests = try mainContext.fetch(fetchRequest)
                test = tests.first
            } catch let fetchError {
                print("Failed to fetch companies: \(fetchError)")
            }
        }

        return test
    }
}
