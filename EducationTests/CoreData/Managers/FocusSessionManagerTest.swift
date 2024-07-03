//
//  FocusSessionManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import XCTest
import CoreData
@testable import Education

class FocusSessionManagerTest: XCTestCase {
    var scheduleManager: ScheduleManager!
    var subjectManager: SubjectManager!
    var focusSessionManager: FocusSessionManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        scheduleManager = ScheduleManager(mainContext: coreDataStack.mainContext,
                                          backgroundContext: coreDataStack.mainContext)
        subjectManager = SubjectManager(mainContext: coreDataStack.mainContext,
                                        backgroundContext: coreDataStack.mainContext)
        focusSessionManager = FocusSessionManager(mainContext: coreDataStack.mainContext,
                                                 backgroundContext: coreDataStack.mainContext)
    }
    
    func test_create_focusSession_with_schedule() {
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB)
        
        let schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!
        
        focusSessionManager.createFocusSession(date: dateA, totalTime: 20, scheduleID: schedule.unwrappedID)
        
        let focusSession = focusSessionManager.fetchFocusSessions(scheduleID: schedule.unwrappedID)!.first!
        
        XCTAssertEqual(focusSession.totalTime, 20)
        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.scheduleID, schedule.unwrappedID)
    }
    
    func test_create_focusSession_without_schedule() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateA = format.date(from: dateStringA)!
        
        focusSessionManager.createFocusSession(date: dateA, totalTime: 20)
        
        let focusSession = focusSessionManager.fetchFocusSessions(scheduleID: nil)!.first!
        
        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.totalTime, 20)
    }
        
    func test_delete_focusSession() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        focusSessionManager.createFocusSession(date: dateA, totalTime: 20)
        focusSessionManager.createFocusSession(date: dateB, totalTime: 20)
        
        var focusSessions = focusSessionManager.fetchFocusSessions(scheduleID: nil)!
        
        XCTAssertEqual(focusSessions.count, 2)
        
        if !focusSessions.isEmpty {
            focusSessionManager.deleteFocusSession(focusSessions[0])
            focusSessions = focusSessionManager.fetchFocusSessions(scheduleID: nil)!
        }
        
        XCTAssertEqual(focusSessions.count, 1)
    }
    
    func test_update_focusSession() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        focusSessionManager.createFocusSession(date: dateA, totalTime: 20)
        
        var focusSession = focusSessionManager.fetchFocusSessions(scheduleID: nil)!.first!
        
        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.totalTime, 20)
        
        focusSession.date = dateB
        focusSession.totalTime = 30
        
        focusSessionManager.updateFocusSession(focusSession)
        
        focusSession = focusSessionManager.fetchFocusSessions(scheduleID: nil)!.first!
        
        XCTAssertEqual(focusSession.date, dateB)
        XCTAssertEqual(focusSession.totalTime, 30)
    }
}

