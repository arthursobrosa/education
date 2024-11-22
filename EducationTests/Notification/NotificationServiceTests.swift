//
//  NotificationServiceTests.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 23/10/24.
//

@testable import Education
import UserNotifications
import XCTest

class MockNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {}

class MockNotificationCenter: UNUserNotificationCenterProtocol {
    var delegate: (any UNUserNotificationCenterDelegate)?
    var pendingRequests: [UNNotificationRequest] = []
    var addRequestExpectation: XCTestExpectation?

    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: (((any Error)?) -> Void)?) {
        addRequestExpectation?.fulfill()
        pendingRequests.append(request)
        completionHandler?(nil)
    }
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, (any Error)?) -> Void) {
        print("Mock center request auth log")
        completionHandler(true, nil)
    }

    func removeAllPendingNotificationRequests() {
        pendingRequests.removeAll()
    }

    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        completionHandler(pendingRequests)
    }

    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        pendingRequests.removeAll { request in
            identifiers.contains(request.identifier)
        }
    }
}

class NotificationServiceTests: XCTestCase {
    var sut: NotificationService!
    var mockNotificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()
        sut = NotificationService()
        sut.notificationCenter = mockNotificationCenter
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSetDelegate() {
        let delegate = MockNotificationCenterDelegate()
        sut.setDelegate(delegate)
        XCTAssertNotNil(mockNotificationCenter.delegate)
    }

    func testRequestAuthorization() {
        let expectation = expectation(description: "Request authorization should've been called")

        sut.requestAuthorization { granted, error in
            XCTAssertTrue(granted)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }

    func testScheduleEndNotification() {
        mockNotificationCenter.addRequestExpectation = expectation(description: "Add request should've been called")

        let title = "Activity finished"
        let subjectName = "Math"
        let date = Date().addingTimeInterval(60)

        sut.scheduleEndNotification(title: title, subjectName: subjectName, date: date)

        waitForExpectations(timeout: 1)

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 1)
        let request = mockNotificationCenter.pendingRequests.first
        XCTAssertEqual(request?.content.title, title)
        XCTAssertEqual(request?.content.body, subjectName)
    }

    func testScheduleWeeklyNotification_exactTime() {
        mockNotificationCenter.addRequestExpectation = expectation(description: "Weekly notification scheduled")

        let title = "Reminder"
        let subjectName = "Math"
        let startTime = Date().addingTimeInterval(60)
        let endTime = Date().addingTimeInterval(120)
        let scheduleInfo = ScheduleInfo(
            subjectName: subjectName,
            dates: (startTime, endTime)
        )

        sut.scheduleWeeklyNotification(
            title: title,
            alarm: 0,
            scheduleInfo: scheduleInfo
        )
        
        let expectedBody = String(format: NSLocalizedString("immediateEvent", comment: ""), subjectName)

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 1)
        let request = mockNotificationCenter.pendingRequests.first
        XCTAssertEqual(request?.content.title, title)
        XCTAssertEqual(request?.content.body, expectedBody)
        XCTAssertNotNil(request?.content.userInfo["subjectName"] as? String)
        XCTAssertNotNil(request?.content.userInfo["startTime"] as? Date)
        XCTAssertNotNil(request?.content.userInfo["endTime"] as? Date)

        let userInfoSubjectName = request?.content.userInfo["subjectName"] as? String
        let userInfoStartTime = request?.content.userInfo["startTime"] as? Date
        let userInfoEndTime = request?.content.userInfo["endTime"] as? Date

        XCTAssertEqual(userInfoSubjectName, subjectName)
        XCTAssertEqual(userInfoStartTime, startTime)
        XCTAssertEqual(userInfoEndTime, endTime)
    }

    func testScheduleWeeklyNotification_notExactTime() {
        mockNotificationCenter.addRequestExpectation = expectation(description: "Weekly notification scheduled")

        let title = "Reminder"
        let subjectName = "Physics"
        let startTime = Date().addingTimeInterval(60)
        let endTime = Date().addingTimeInterval(120)
        let scheduleInfo = ScheduleInfo(
            subjectName: subjectName,
            dates: (startTime, endTime)
        )

        sut.scheduleWeeklyNotification(
            title: title,
            alarm: 3,
            scheduleInfo: scheduleInfo
        )
        
        let expectedBody = String(format: NSLocalizedString("comingEvent", comment: ""), subjectName)

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 1)
        let request = mockNotificationCenter.pendingRequests.first
        XCTAssertEqual(request?.content.title, title)
        XCTAssertEqual(request?.content.body, expectedBody)

        guard let request else { return }

        XCTAssertTrue(request.content.userInfo.isEmpty)
    }

    func testCancelAllNotifications() {
        sut.scheduleEndNotification(title: "Activity finished", subjectName: "Math", date: Date().addingTimeInterval(60))
        
        let subjectName = "Chemistry"
        let startTime = Date().addingTimeInterval(60)
        let endTime = Date().addingTimeInterval(120)
        let scheduleInfo = ScheduleInfo(
            subjectName: subjectName,
            dates: (startTime, endTime)
        )

        sut.scheduleWeeklyNotification(
            title: "Reminder",
            alarm: 1,
            scheduleInfo: scheduleInfo
        )

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 2)

        sut.cancelAllNotifications()

        XCTAssertTrue(mockNotificationCenter.pendingRequests.isEmpty)
    }

    func testCancelNotificationByName() {
        let subjectName = "Math"

        sut.scheduleEndNotification(title: "Activity finished", subjectName: subjectName, date: Date().addingTimeInterval(60))

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 1)

        sut.cancelNotificationByName(name: subjectName)

        XCTAssertTrue(mockNotificationCenter.pendingRequests.isEmpty)
    }

    func testCancelNoficationsForDate() {
        let subjectName = "Physics"
        let startTime = Date().addingTimeInterval(60)
        let endTime = Date().addingTimeInterval(120)
        let scheduleInfo = ScheduleInfo(
            subjectName: subjectName,
            dates: (startTime, endTime)
        )

        sut.scheduleWeeklyNotification(
            title: "Reminder",
            alarm: 0,
            scheduleInfo: scheduleInfo
        )

        XCTAssertEqual(mockNotificationCenter.pendingRequests.count, 1)

        sut.cancelNotifications(forDate: startTime)

        XCTAssertTrue(mockNotificationCenter.pendingRequests.isEmpty)
    }

    func testGetActiveNotifications() {
        sut.scheduleEndNotification(title: "Activity Finished", subjectName: "Math", date: Date().addingTimeInterval(60))

        let expectation = expectation(description: "Get active notifications")

        sut.getActiveNotifications { requests in
            XCTAssertEqual(requests.count, 1)
            XCTAssertEqual(requests.first?.content.title, "Activity Finished")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}
