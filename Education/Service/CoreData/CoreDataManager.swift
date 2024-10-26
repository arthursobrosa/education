//
//  CoreDataManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Subject CRUD

    func createSubject(name: String) {
        guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: appDelegate.context) as? Subject else {
            return
        }

        subject.name = name
        subject.id = UUID().uuidString

        appDelegate.saveContext()
    }

    func fetchSubject(_ id: String) -> Subject? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let subjects = try appDelegate.context.fetch(fetchRequest)
            return subjects.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func fetchSubjects() -> [Subject]? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")

        do {
            let subjects = try appDelegate.context.fetch(fetchRequest)
            return subjects
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func updateSubject(_ subject: Subject) {
        guard let subjectToUpdate = fetchSubject(subject.unwrappedID) else {
            return
        }

        subjectToUpdate.name = subject.name

        appDelegate.saveContext()
    }

    func deleteSubject(_ subject: Subject) {
        guard let schedules = fetchSchedules(subjectID: subject.unwrappedID) else { return }
        for schedule in schedules {
            deleteSchedule(schedule)
        }

        appDelegate.context.delete(subject)
        appDelegate.saveContext()
    }

    // MARK: - Schedule CRUD

    func createSchedule(subjectID: String, dayOfTheWeek: Int, startTime: Date, endTime: Date) {
        guard let schedule = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: appDelegate.context) as? Schedule else {
            return
        }

        schedule.subjectID = subjectID
        schedule.dayOfTheWeek = Int16(dayOfTheWeek)
        schedule.startTime = startTime
        schedule.endTime = endTime
        schedule.id = UUID().uuidString

        appDelegate.saveContext()
    }

    func fetchSchedule(from id: String) -> Schedule? {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            let schedules = try appDelegate.context.fetch(fetchRequest)
            return schedules.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
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

        do {
            let schedules = try appDelegate.context.fetch(fetchRequest)
            return schedules
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func updateSchedule(_ schedule: Schedule) {
        guard let scheduleToUpdate = fetchSchedule(from: schedule.unwrappedID) else {
            return
        }

        scheduleToUpdate.dayOfTheWeek = schedule.dayOfTheWeek
        scheduleToUpdate.startTime = schedule.startTime
        scheduleToUpdate.endTime = schedule.endTime

        appDelegate.saveContext()
    }

    func deleteSchedule(_ schedule: Schedule) {
        guard let focusSessions = fetchFocusSessions(from: schedule.unwrappedID) else { return }
        for focusSession in focusSessions {
            deleteFocusSession(focusSession)
        }

        appDelegate.delete(schedule)
        appDelegate.saveContext()
    }

    // MARK: - FocusSession CRUD

    func createFocusSession(date: Date, totalTime: Int, scheduleID: String? = nil) {
        guard let focusSession = NSEntityDescription.insertNewObject(forEntityName: "FocusSession", into: appDelegate.context) as? FocusSession else {
            return
        }

        focusSession.date = date
        focusSession.totalTime = Int16(totalTime)
        focusSession.scheduleID = scheduleID
        focusSession.id = UUID().uuidString

        appDelegate.saveContext()
    }

    func fetchAllFocusSessions() -> [FocusSession]? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")

        do {
            let focusSessions = try appDelegate.context.fetch(fetchRequest)
            return focusSessions
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func fetchFocusSessions(from scheduleID: String) -> [FocusSession]? {
        guard let allFocusSessions = fetchAllFocusSessions() else { return nil }
        let filteredFocusSessions = allFocusSessions.compactMap { focusSession in
            if focusSession.scheduleID == scheduleID {
                return focusSession
            }

            return nil
        }

        return filteredFocusSessions
    }

    func fetchFocusSessionsLoose() -> [FocusSession]? {
        guard let allFocusSessions = fetchAllFocusSessions() else { return nil }
        let filteredFocusSessions = allFocusSessions.compactMap { focusSession in
            if focusSession.scheduleID == nil {
                return focusSession
            }
            return nil
        }
        return filteredFocusSessions
    }

    func fetchFocusSession(from id: String) -> FocusSession? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            let focusSessions = try appDelegate.context.fetch(fetchRequest)
            return focusSessions.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func updateFocusSession(_ focusSession: FocusSession) {
        guard let focusSessionToUpdate = fetchFocusSession(from: focusSession.unwrappedID) else {
            return
        }

        focusSessionToUpdate.date = focusSession.date
        focusSessionToUpdate.totalTime = focusSession.totalTime

        appDelegate.saveContext()
    }

    func deleteFocusSession(_ focusSession: FocusSession) {
        appDelegate.delete(focusSession)
        appDelegate.saveContext()
    }

    // MARK: - Theme CRUD

    func createTheme(name: String) {
        guard let theme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: appDelegate.context) as? Theme else {
            return
        }

        theme.name = name
        theme.id = UUID().uuidString

        appDelegate.saveContext()
    }

    func fetchTheme(_ id: String) -> Theme? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let themes = try appDelegate.context.fetch(fetchRequest)
            return themes.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func fetchThemes() -> [Theme]? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")

        do {
            let themes = try appDelegate.context.fetch(fetchRequest)
            return themes
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func updateTheme(_ theme: Theme) {
        guard let themeToUpdate = fetchSubject(theme.unwrappedID) else {
            return
        }

        themeToUpdate.name = theme.name

        appDelegate.saveContext()
    }

    func deleteTheme(_ theme: Theme) {
        guard let tests = fetchTests(from: theme.unwrappedID) else { return }
        for test in tests {
            deleteTest(test)
        }

        appDelegate.context.delete(theme)
        appDelegate.saveContext()
    }

    // MARK: - Test CRUD

    func createTest(themeID: String, date: Date, rightQuestions: Int, totalQuestions: Int) {
        guard let test = NSEntityDescription.insertNewObject(forEntityName: "Test", into: appDelegate.context) as? Test else {
            return
        }

        test.themeID = themeID
        test.date = date
        test.rightQuestions = Int16(rightQuestions)
        test.totalQuestions = Int16(totalQuestions)
        test.id = UUID().uuidString

        appDelegate.saveContext()
    }

    func fetchTests(from themeID: String) -> [Test]? {
        let fetchRequest = NSFetchRequest<Test>(entityName: "Test")
        fetchRequest.predicate = NSPredicate(format: "themeID == %@", themeID)

        do {
            let themes = try appDelegate.context.fetch(fetchRequest)
            return themes
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func fetchTest(from id: String) -> Test? {
        let fetchRequest = NSFetchRequest<Test>(entityName: "Test")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            let tests = try appDelegate.context.fetch(fetchRequest)
            return tests.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }

    func updateTest(_ test: Test) {
        guard let testToUpdate = fetchTest(from: test.unwrappedID) else {
            return
        }

        testToUpdate.date = test.date
        testToUpdate.rightQuestions = test.rightQuestions
        testToUpdate.totalQuestions = test.totalQuestions

        appDelegate.saveContext()
    }

    func deleteTest(_ test: Test) {
        appDelegate.context.delete(test)
        appDelegate.saveContext()
    }
}
