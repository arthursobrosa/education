//
//  SubjectManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import XCTest
import CoreData
@testable import Education

class SubjectManagerTest: XCTestCase {
    var subjectManager: SubjectManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        subjectManager = SubjectManager(mainContext: coreDataStack.mainContext,
                                                 backgroundContext: coreDataStack.mainContext)
        subjectManager.scheduleManager = ScheduleManager(mainContext: coreDataStack.mainContext,
                                                         backgroundContext: coreDataStack.mainContext)
    }
    
    func test_create_subject() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")
        let subject = subjectManager.fetchSubject(withName: "Math")!

        XCTAssertEqual("Math", subject.unwrappedName)
    }
        
    func test_delete_subject() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")
        subjectManager.createSubject(name: "Geography", color: "FocusSelectionColor")
        subjectManager.createSubject(name: "Science", color: "FocusSelectionColor")
        
        let subjectA = subjectManager.fetchSubject(withName: "Math")!
        let subjectB = subjectManager.fetchSubject(withName: "Geography")!
        let subjectC = subjectManager.fetchSubject(withName: "Science")!
        
        subjectManager.deleteSubject(subjectB)

        let subjects = subjectManager.fetchSubjects()!
        
        XCTAssertEqual(subjects.count, 2)
        XCTAssertTrue(subjects.contains(subjectA))
        XCTAssertTrue(subjects.contains(subjectC))
    }
    
    func test_update_subject() {
        subjectManager.createSubject(name: "Math", color: "FocusSelectionColor")
        
        let subject = subjectManager.fetchSubject(withName: "Math")!
        
        XCTAssertEqual(subject.unwrappedName, "Math")
        
        subject.name = "Geography"
        
        subjectManager.updateSubject(subject)
        
        let updatedSubject = subjectManager.fetchSubject(withName: "Geography")!
        
        XCTAssertEqual(updatedSubject.unwrappedName, "Geography")
    }
}
