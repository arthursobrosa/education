//
//  SubjectManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import CoreData
import UIKit

final class SubjectManager: ObjectManager {
    lazy var focusSessionManager = FocusSessionManager()
    lazy var scheduleManager = ScheduleManager()

    // MARK: - Create

    func createSubject(name: String, color: String) {
        backgroundContext.performAndWait {
            guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: backgroundContext) as? Subject else { return }

            subject.name = name
            subject.color = color
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

            for schedule in schedules {
                self.scheduleManager.deleteSchedule(schedule)
            }

            if let focusSessions = self.focusSessionManager.fetchFocusSessions(subjectID: subject.unwrappedID) {
                for focusSession in focusSessions {
                    self.focusSessionManager.deleteFocusSession(focusSession)
                }
            }

            do {
                let subjectInContext = try backgroundContext.existingObject(with: objectID)
                backgroundContext.delete(subjectInContext)

                try? backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            } catch {
                print("Failed to get object \(error)")
            }
        }
    }

    // MARK: - Update

    func updateSubject(_: Subject) {
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                CoreDataStack.shared.saveMainContext()
            } catch {
                print("Failed to update \(error)")
            }
        }
    }

    // MARK: - Fetch

    func fetchSubject(withID id: String? = nil, withName name: String? = nil) -> Subject? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")

        if let id {
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        } else if let name {
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
            } catch {
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
            } catch {
                print("Failed to fetch: \(error)")
            }
        }

        return subjects
    }

    func enemMode() {
        // let uspSubjects = ["Biologia", "Física", "Geografia", "História", "Inglês", "Matemática", "Português", "Química"]
        // let ufpaSubjects = ["Biologia", "Filosofia", "Física", "Geografia", "História", "Literatura", "Matemática", "Português", "Química", "Sociologia"]

        let enemSubjects = ["Português", "Literatura", "Inglês/Espanhol", "Artes", "Ed. Física", "Tec. Informação", "História", "Geografia", "Filosofia", "Sociologia", "Química", "Física", "Biologia", "Matemática"]
//        let publicTenderSubjects = ["Língua Portuguesa", "Raciocínio Lógico", "Informatica" ,"Matemática Básica", "Atualidades", "Redação", "Legislação"]
//        let medicineSubjects = ["Legislação SUS", "Artigos 196-200", "Lei Orgân. 8080", "Decreto 7.508", "PNAB", "PNH"] //Considerar aumentar de 15 pra 18 o limite

        for subject in enemSubjects {
            createSubject(name: subject, color: "turquoisePicker")
        }
    }
}
