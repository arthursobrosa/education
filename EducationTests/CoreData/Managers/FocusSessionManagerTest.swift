//
//  FocusSessionManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import CoreData
@testable import Education
import XCTest

// swiftlint:disable force_unwrapping
class FocusSessionManagerTest: XCTestCase {
    var subjectManager: SubjectManager!
    var focusSessionManager: FocusSessionManager!
    var coreDataStack: CoreDataTestStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        subjectManager = SubjectManager(mainContext: coreDataStack.mainContext,
                                        backgroundContext: coreDataStack.mainContext)
        focusSessionManager = FocusSessionManager(mainContext: coreDataStack.mainContext,
                                                  backgroundContext: coreDataStack.mainContext)
    }

    func test_create_focusSession_with_subject() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateA = format.date(from: dateStringA)!
        let notes = "Greates focus session ever!"

        focusSessionManager.createFocusSession(
            date: dateA,
            totalTime: 20,
            subjectID: subject.unwrappedID,
            notes: notes
        )

        let focusSession = focusSessionManager.fetchFocusSessions(subjectID: subject.unwrappedID)!.first!

        XCTAssertEqual(focusSession.totalTime, 20)
        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.subjectID, subject.unwrappedID)
        XCTAssertEqual(focusSession.notes, notes)
    }

    func test_fetch_single_focusSession() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")

        let subject = subjectManager.fetchSubject(withName: "Math")!

        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateA = format.date(from: dateStringA)!
        let notes = "Notes"

        focusSessionManager.createFocusSession(
            date: dateA,
            totalTime: 20,
            subjectID: subject.unwrappedID,
            notes: notes
        )

        let focusSession = focusSessionManager.fetchFocusSessions(subjectID: subject.unwrappedID)!.first!
        let focusSessionId = focusSession.id!
        let individualFocusSession = focusSessionManager.fetchFocusSession(withID: focusSessionId)!

        XCTAssertEqual(focusSession.id, individualFocusSession.id)
        XCTAssertEqual(focusSession.notes, notes)
    }

    func test_create_focusSession_without_subject() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateA = format.date(from: dateStringA)!
        let notes = "Another note"

        focusSessionManager.createFocusSession(
            date: dateA,
            totalTime: 20,
            notes: notes
        )

        let focusSession = focusSessionManager.fetchFocusSessions(subjectID: nil)!.first!

        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.totalTime, 20)
        XCTAssertEqual(focusSession.notes, notes)
    }

    func test_delete_focusSession() {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!

        focusSessionManager.createFocusSession(date: dateA, totalTime: 20, notes: String())
        focusSessionManager.createFocusSession(date: dateB, totalTime: 20, notes: String())

        var focusSessions = focusSessionManager.fetchFocusSessions(subjectID: nil)!

        XCTAssertEqual(focusSessions.count, 2)

        if !focusSessions.isEmpty {
            focusSessionManager.deleteFocusSession(focusSessions[0])
            focusSessions = focusSessionManager.fetchFocusSessions(subjectID: nil)!
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

        focusSessionManager.createFocusSession(date: dateA, totalTime: 20, notes: String())

        var focusSession = focusSessionManager.fetchFocusSessions(subjectID: nil)!.first!

        XCTAssertEqual(focusSession.date, dateA)
        XCTAssertEqual(focusSession.totalTime, 20)

        focusSession.date = dateB
        focusSession.totalTime = 30

        focusSessionManager.updateFocusSession(focusSession)

        focusSession = focusSessionManager.fetchFocusSessions(subjectID: nil)!.first!

        XCTAssertEqual(focusSession.date, dateB)
        XCTAssertEqual(focusSession.totalTime, 30)
    }
}
// swiftlint:enable force_unwrapping
