//
//  ScheduleManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import CoreData
@testable import Education
import XCTest

// swiftlint:disable force_unwrapping
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
    }

    func test_create_schedule() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        let completionDate = Date()
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [1, 2, 3],
            completed: true,
            completionDate: completionDate
        )

        let schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!

        XCTAssertEqual(schedule.dayOfTheWeek, 4)
        XCTAssertEqual(schedule.startTime, startTime)
        XCTAssertEqual(schedule.endTime, endTime)
        XCTAssertEqual(schedule.completed, true)
        XCTAssertEqual(schedule.completionDate, completionDate)
    }

    func test_fetch_single_schedule() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [1, 2, 3]
        )

        let schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!
        let scheduleId = schedule.id!
        let individualSchedule = scheduleManager.fetchSchedule(from: scheduleId)!

        XCTAssertEqual(schedule.dayOfTheWeek, individualSchedule.dayOfTheWeek)
    }

    func test_delete_schedule() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0]
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 5,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0]
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 6,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0]
        )

        var schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!

        XCTAssertEqual(schedules.count, 3)

        if !schedules.isEmpty {
            scheduleManager.deleteSchedule(schedules[0])
            schedules = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!
        }

        XCTAssertEqual(schedules.count, 2)
    }

    func test_update_schedule() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0],
            completed: true
        )

        var schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!

        XCTAssertEqual(schedule.dayOfTheWeek, 4)

        schedule.dayOfTheWeek = 5
        schedule.completed = false

        scheduleManager.updateSchedule(schedule)

        schedule = scheduleManager.fetchSchedules(subjectID: subject.unwrappedID)!.first!

        XCTAssertEqual(schedule.dayOfTheWeek, 5)
        XCTAssertEqual(schedule.completed, false)
    }

    func test_fetch_schedules_by_day_of_the_week() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 3,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0]
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0]
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 4,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [1]
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: 5,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [2, 3]
        )

        let wednesdaySchedules = scheduleManager.fetchSchedules(dayOfTheWeek: 3)!
        let thursdaySchedules = scheduleManager.fetchSchedules(dayOfTheWeek: 4)!

        XCTAssertEqual(wednesdaySchedules.count, 1)
        XCTAssertEqual(thursdaySchedules.count, 2)

        XCTAssertEqual(wednesdaySchedules.first?.dayOfTheWeek, 3)
        XCTAssertEqual(thursdaySchedules.first?.dayOfTheWeek, 4)
    }
    
    func testRefreshSchedules() {
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: Date()) - 1
        
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTimeString = "2023-11-13 09:12:22"
        let endTimeString = "2023-11-13 10:12:22"
        let startTime = format.date(from: startTimeString)!
        let endTime = format.date(from: endTimeString)!
        
        let todayDate = Date()
        let lastWeekDate = calendar.date(byAdding: .day, value: -7, to: todayDate)!
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: weekDay,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0],
            completed: true,
            completionDate: todayDate
        )
        
        scheduleManager.createSchedule(
            subjectID: subject.unwrappedID,
            dayOfTheWeek: weekDay,
            startTime: startTime,
            endTime: endTime,
            blocksApps: false,
            alarms: [0],
            completed: true,
            completionDate: lastWeekDate
        )
        
        let schedules = scheduleManager.fetchSchedules()!.sorted { $0.unwrappedCompletionDate < $1.unwrappedCompletionDate }
        
        XCTAssertEqual(schedules.count, 2)
        XCTAssertEqual(schedules[0].unwrappedCompletionDate, lastWeekDate)
        XCTAssertEqual(schedules[0].completed, true)
        XCTAssertEqual(schedules[1].unwrappedCompletionDate, todayDate)
        XCTAssertEqual(schedules[1].completed, true)
        
        scheduleManager.refreshSchedules()
        
        XCTAssertEqual(schedules.count, 2)
        XCTAssertEqual(schedules[0].unwrappedCompletionDate, lastWeekDate)
        XCTAssertEqual(schedules[0].completed, false)
        XCTAssertEqual(schedules[1].unwrappedCompletionDate, todayDate)
        XCTAssertEqual(schedules[1].completed, true)
    }
}
// swiftlint:enable force_unwrapping
