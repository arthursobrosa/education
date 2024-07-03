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

        testManager.createTest(themeID: theme.unwrappedID, date: date, rightQuestions: 25, totalQuestions: 30)
        
        let test = testManager.fetchTests(themeID: theme.unwrappedID)!.first!
        
        XCTAssertEqual(test.date, date)
        XCTAssertEqual(test.rightQuestions, 25)
        XCTAssertEqual(test.totalQuestions, 30)
    }
        
//    func test_delete_test() {
//        testManager.createTest(name: "Math + Geo")
//        testManager.createTest(name: "Math + Science")
//        
//        var tests = testManager.fetchTests()!
//        
//        XCTAssertEqual(tests.count, 2)
//        
//        let test = testManager.fetchTest(withName: "Math + Geo")!
//        
//        testManager.deleteTest(test)
//        
//        tests = testManager.fetchTests()!
//        
//        XCTAssertEqual(tests.count, 1)
//    }
//    
//    func test_update_test() {
//        testManager.createTest(name: "Math + Geo")
//        
//        let test = testManager.fetchTest(withName: "Math + Geo")!
//        
//        XCTAssertEqual(test.unwrappedName, "Math + Geo")
//        
//        test.name = "Just math"
//        
//        testManager.updateTest(test)
//        
//        let testUpdated = testManager.fetchTest(withName: "Just math")!
//        
//        XCTAssertEqual(testUpdated.unwrappedName, "Just math")
//        
//    }
}

