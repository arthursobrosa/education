//
//  ScheduleManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import XCTest
import CoreData
@testable import Education

class ScheduleManagerTest: XCTestCase {
    var subjectManager: SubjectManager!
    var scheduleManager: ScheduleManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        subjectManager = SubjectManager(mainContext: coreDataStack.mainContext,
                                                 backgroundContext: coreDataStack.mainContext)
        scheduleManager = ScheduleManager(mainContext: coreDataStack.mainContext,
                                                 backgroundContext: coreDataStack.mainContext)
        scheduleManager.focusSessionManager = FocusSessionManager(mainContext: coreDataStack.mainContext,
                                                                  backgroundContext: coreDataStack.mainContext)
    }
    
    func test_create_schedule() {
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        
        let schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!

        XCTAssertEqual(schedule.dayOfTheWeek, 4)
        XCTAssertEqual(schedule.startTime, dateA)
        XCTAssertEqual(schedule.endTime, dateB)
    }
    
    func test_fetch_single_schedule() {
        
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!

        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        
        
        let schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!
        
        let scheduleId = schedule.id!
        
        let individualSchedule = scheduleManager.fetchSchedule(from: scheduleId)!
        
        XCTAssertEqual(schedule.dayOfTheWeek, individualSchedule.dayOfTheWeek)
       
    }
        
    func test_delete_schedule() {
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 5, startTime: dateA, endTime: dateB, blocksApps: false)
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 6, startTime: dateA, endTime: dateB, blocksApps: false)
        
        var schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!
        
        XCTAssertEqual(schedules.count, 3)
        
        if !schedules.isEmpty {
            scheduleManager.deleteSchedule(schedules[0])
            schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!
        }
        
        XCTAssertEqual(schedules.count, 2)
    }
    
    func test_update_schedule() {
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        
        var schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!
        
        XCTAssertEqual(schedule.dayOfTheWeek, 4)
        
        schedule.dayOfTheWeek = 5
        
        scheduleManager.updateSchedule(schedule)
        
        schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!
        
        XCTAssertEqual(schedule.dayOfTheWeek, 5)
    }
    
    func test_fetch_schedules_by_day_of_the_week() {
        subjectManager.createSubject(name: "Math")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
      
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 3, startTime: dateA, endTime: dateB, blocksApps: false)
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 4, startTime: dateA, endTime: dateB, blocksApps: false)
        scheduleManager.createSchedule(subjectID: subject.unwrappedID, dayOfTheWeek: 5, startTime: dateA, endTime: dateB, blocksApps: false)
      
        let wednesdaySchedules = scheduleManager.fetchSchedules(dayOfTheWeek: 3)!
        let thursdaySchedules = scheduleManager.fetchSchedules(dayOfTheWeek: 4)!
        
        XCTAssertEqual(wednesdaySchedules.count, 1)
        XCTAssertEqual(thursdaySchedules.count, 2)
        
        XCTAssertEqual(wednesdaySchedules.first?.dayOfTheWeek, 3)
        XCTAssertEqual(thursdaySchedules.first?.dayOfTheWeek, 4)
    }
}
