//
//  TestManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import XCTest
import CoreData
@testable import Education

class TestManagerTest: XCTestCase {
    var testManager: TestManager!
    var themeManager: ThemeManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        testManager = TestManager(mainContext: coreDataStack.mainContext,
                                          backgroundContext: coreDataStack.mainContext)
        themeManager = ThemeManager(mainContext: coreDataStack.mainContext,
                                    backgroundContext: coreDataStack.mainContext)
        
    }
    
    func test_create_test() {
        
         themeManager.createTheme(name: "Math")
        
        let theme = themeManager.fetchTheme(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-11-13 09:12:22"
        let date = format.date(from: dateString)!

        testManager.createTest(themeID: theme.unwrappedID, date: date, rightQuestions: 25, totalQuestions: 30, comment: "test")
        
        let test = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        XCTAssertEqual(test.date, date)
        XCTAssertEqual(test.rightQuestions, 25)
        XCTAssertEqual(test.totalQuestions, 30)
        XCTAssertEqual(test.unwrappedComment, "test")
    }
    
    func test_fetch_single_test() {
        
        themeManager.createTheme(name: "Math")
        
        let theme = themeManager.fetchTheme(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-11-13 09:12:22"
        let date = format.date(from: dateString)!

        testManager.createTest(themeID: theme.unwrappedID, date: date, rightQuestions: 25, totalQuestions: 30)
        
        
        
        let test = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        let testId = test.id!
        
        let individualTest = testManager.fetchTest(id: testId)!
        
        XCTAssertEqual(test.date, individualTest.date)
        XCTAssertEqual(test.rightQuestions, individualTest.rightQuestions)
        XCTAssertEqual(test.totalQuestions, individualTest.totalQuestions)
    }
        
    func test_delete_test() {
        themeManager.createTheme(name: "Math")
        
        let theme = themeManager.fetchTheme(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStringA = "2023-11-13 09:12:22"
        let dateStringB = "2023-11-13 10:12:22"
        let dateA = format.date(from: dateStringA)!
        let dateB = format.date(from: dateStringB)!
        
        testManager.createTest(themeID: theme.unwrappedID, date: dateA, rightQuestions: 25, totalQuestions: 30)
        testManager.createTest(themeID: theme.unwrappedID, date: dateB, rightQuestions: 10, totalQuestions: 15)
        
        var tests = testManager.fetchTests(themeID: theme.unwrappedID)!
        
        XCTAssertEqual(tests.count, 2)
        
        let test = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        testManager.deleteTest(test)
        
        tests = testManager.fetchTests(themeID: theme.unwrappedID)!
        
        XCTAssertEqual(tests.count, 1)
        
    }
    
    func test_update_test() {
        themeManager.createTheme(name: "Math")
        
        let theme = themeManager.fetchTheme(withName: "Math")!
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = "2023-11-13 09:12:22"
        let date = format.date(from: dateString)!

        testManager.createTest(themeID: theme.unwrappedID, date: date, rightQuestions: 25, totalQuestions: 30, comment:"test")
        
        let test = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        test.rightQuestions = 7
        test.totalQuestions = 20
        test.comment = "updatedTest"
        
        let dateStringB = "2023-11-13 10:12:22"
        let dateB = format.date(from: dateStringB)!
        test.date = dateB
        
        testManager.updateTest(test)
        
        let testUpdated = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        XCTAssertEqual(testUpdated.date, dateB)
        XCTAssertEqual(testUpdated.rightQuestions, 7)
        XCTAssertEqual(testUpdated.totalQuestions, 20)
        XCTAssertEqual(testUpdated.unwrappedComment, "updatedTest")
        
    }
}

