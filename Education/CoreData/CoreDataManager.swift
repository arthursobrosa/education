//
//  CoreDataManager.swift
//  Education
//
//  Created by Arthur Sobrosa on 26/06/24.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Subject CRUD
    func createSubject(name: String) {
        guard let subject = NSEntityDescription.insertNewObject(forEntityName: "Subject", into: self.appDelegate.context) as? Subject else {
            return
        }
        
        subject.name = name
        subject.id = UUID().uuidString
        
        self.appDelegate.saveContext()
    }
    
    func fetchSubject(_ id: String) -> Subject? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let subjects = try self.appDelegate.context.fetch(fetchRequest)
            return subjects.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func fetchSubjects() -> [Subject]? {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        
        do {
            let subjects = try self.appDelegate.context.fetch(fetchRequest)
            return subjects
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func updateSubject(_ subject: Subject) {
        guard let subjectToUpdate = self.fetchSubject(subject.unwrappedID) else {
            return
        }
        
        subjectToUpdate.name = subject.name
        
        self.appDelegate.saveContext()
    }
    
    func deleteSubject(_ subject: Subject) {
        guard let schedules = self.fetchSchedules(subjectID: subject.unwrappedID) else { return }
        schedules.forEach { schedule in
            self.deleteSchedule(schedule)
        }
        
        self.appDelegate.context.delete(subject)
        self.appDelegate.saveContext()
    }
    
    // MARK: - Schedule CRUD
    func createSchedule(subjectID: String, dayOfTheWeek: Int, startTime: Date, endTime: Date) {
        guard let schedule = NSEntityDescription.insertNewObject(forEntityName: "Schedule", into: self.appDelegate.context) as? Schedule else {
            return
        }
        
        schedule.subjectID = subjectID
        schedule.dayOfTheWeek = Int16(dayOfTheWeek)
        schedule.startTime = startTime
        schedule.endTime = endTime
        schedule.id = UUID().uuidString
        
        self.appDelegate.saveContext()
    }
    
    func fetchSchedule(from id: String) -> Schedule? {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let schedules = try self.appDelegate.context.fetch(fetchRequest)
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
            let schedules = try self.appDelegate.context.fetch(fetchRequest)
            return schedules
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func updateSchedule(_ schedule: Schedule) {
        guard let scheduleToUpdate = self.fetchSchedule(from: schedule.unwrappedID) else {
            return
        }
        
        scheduleToUpdate.dayOfTheWeek = schedule.dayOfTheWeek
        scheduleToUpdate.startTime = schedule.startTime
        scheduleToUpdate.endTime = schedule.endTime
        
        self.appDelegate.saveContext()
    }
    
    func deleteSchedule(_ schedule: Schedule) {
        guard let focusSessions = self.fetchFocusSessions(from: schedule.unwrappedID) else { return }
        focusSessions.forEach { focusSession in
            self.deleteFocusSession(focusSession)
        }
        
        self.appDelegate.delete(schedule)
        self.appDelegate.saveContext()
    }
    
    // MARK: - FocusSession CRUD
    func createFocusSession(date: Date, totalTime: Int, scheduleID: String? = nil) {
        guard let focusSession = NSEntityDescription.insertNewObject(forEntityName: "FocusSession", into: self.appDelegate.context) as? FocusSession else {
            return
        }
        
        focusSession.date = date
        focusSession.totalTime = Int16(totalTime)
        focusSession.scheduleID = scheduleID
        focusSession.id = UUID().uuidString
        
        self.appDelegate.saveContext()
    }
    
    func fetchAllFocusSessions() -> [FocusSession]? {
        let fetchRequest = NSFetchRequest<FocusSession>(entityName: "FocusSession")
        
        do {
            let focusSessions = try self.appDelegate.context.fetch(fetchRequest)
            return focusSessions
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func fetchFocusSessions(from scheduleID: String) -> [FocusSession]? {
        guard let allFocusSessions = self.fetchAllFocusSessions() else { return nil }
        let filteredFocusSessions = allFocusSessions.compactMap { focusSession in
            if focusSession.scheduleID == scheduleID {
                return focusSession
            }
            
            return nil
        }
        
        return filteredFocusSessions
    }
    
    func fetchFocusSessionsLoose() -> [FocusSession]?{
        guard let allFocusSessions = self.fetchAllFocusSessions() else { return nil }
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
            let focusSessions = try self.appDelegate.context.fetch(fetchRequest)
            return focusSessions.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func updateFocusSession(_ focusSession: FocusSession) {
        guard let focusSessionToUpdate = self.fetchFocusSession(from: focusSession.unwrappedID) else {
            return
        }
        
        focusSessionToUpdate.date = focusSession.date
        focusSessionToUpdate.totalTime = focusSession.totalTime
        
        self.appDelegate.saveContext()
    }
    
    func deleteFocusSession(_ focusSession: FocusSession) {
        self.appDelegate.delete(focusSession)
        self.appDelegate.saveContext()
    }
    
    // MARK: - Theme CRUD
    func createTheme(name: String) {
        guard let theme = NSEntityDescription.insertNewObject(forEntityName: "Theme", into: self.appDelegate.context) as? Theme else {
            return
        }
        
        theme.name = name
        theme.id = UUID().uuidString
        
        self.appDelegate.saveContext()
    }
    
    func fetchTheme(_ id: String) -> Theme? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let themes = try self.appDelegate.context.fetch(fetchRequest)
            return themes.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func fetchThemes() -> [Theme]? {
        let fetchRequest = NSFetchRequest<Theme>(entityName: "Theme")
        
        do {
            let themes = try self.appDelegate.context.fetch(fetchRequest)
            return themes
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func updateTheme(_ theme: Theme) {
        guard let themeToUpdate = self.fetchSubject(theme.unwrappedID) else {
            return
        }
        
        themeToUpdate.name = theme.name
        
        self.appDelegate.saveContext()
    }
    
    func deleteTheme(_ theme: Theme) {
        guard let tests = self.fetchTests(from: theme.unwrappedID) else { return }
        tests.forEach { test in
            self.deleteTest(test)
        }
        
        self.appDelegate.context.delete(theme)
        self.appDelegate.saveContext()
    }
    
    // MARK: - Test CRUD
    func createTest(themeID: String, date: Date, rightQuestions: Int, totalQuestions: Int)  {
        guard let test = NSEntityDescription.insertNewObject(forEntityName: "Test", into: self.appDelegate.context) as? Test else {
            return
        }
        
        test.themeID = themeID
        test.date = date
        test.rightQuestions = Int16(rightQuestions)
        test.totalQuestions = Int16(totalQuestions)
        test.id = UUID().uuidString
        
        self.appDelegate.saveContext()
    }
    
    func fetchTests(from themeID: String) -> [Test]? {
        let fetchRequest = NSFetchRequest<Test>(entityName: "Test")
        fetchRequest.predicate = NSPredicate(format: "themeID == %@", themeID)
        
        do {
            let themes = try self.appDelegate.context.fetch(fetchRequest)
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
            let tests = try self.appDelegate.context.fetch(fetchRequest)
            return tests.first
        } catch let fetchError {
            print("Failed to fetch companies: \(fetchError)")
            return nil
        }
    }
    
    func updateTest(_ test: Test) {
        guard let testToUpdate = self.fetchTest(from: test.unwrappedID) else {
            return
        }
        
        testToUpdate.date = test.date
        testToUpdate.rightQuestions = test.rightQuestions
        testToUpdate.totalQuestions = test.totalQuestions
        
        self.appDelegate.saveContext()
    }
    
    func deleteTest(_ test: Test) {
        self.appDelegate.context.delete(test)
        self.appDelegate.saveContext()
    }
}
