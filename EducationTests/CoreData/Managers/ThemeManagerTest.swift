//
//  ThemeManagerTest.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 02/07/24.
//

import XCTest
import CoreData
@testable import Education

class ThemeManagerTest: XCTestCase {
    var themeManager: ThemeManager!
    var coreDataStack: CoreDataTestStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        themeManager = ThemeManager(mainContext: coreDataStack.mainContext,
                                          backgroundContext: coreDataStack.mainContext)
        themeManager.testManager = TestManager(mainContext: coreDataStack.mainContext,
                                               backgroundContext: coreDataStack.mainContext)
    }
    
    func test_create_theme() {
        themeManager.createTheme(name: "Math + Geo")
        
        let theme = themeManager.fetchTheme(withName: "Math + Geo")!
        
        XCTAssertEqual(theme.unwrappedName, "Math + Geo")
    }
        
    func test_delete_theme() {
        themeManager.createTheme(name: "Math + Geo")
        themeManager.createTheme(name: "Math + Science")
        
        var themes = themeManager.fetchThemes()!
        
        XCTAssertEqual(themes.count, 2)
        
        let theme = themeManager.fetchTheme(withName: "Math + Geo")!
        
        themeManager.deleteTheme(theme)
        
        themes = themeManager.fetchThemes()!
        
        XCTAssertEqual(themes.count, 1)
    }
    
    func test_update_theme() {
        themeManager.createTheme(name: "Math + Geo")
        
        let theme = themeManager.fetchTheme(withName: "Math + Geo")!
        
        XCTAssertEqual(theme.unwrappedName, "Math + Geo")
        
        theme.name = "Just math"
        
        themeManager.updateTheme(theme)
        
        let themeUpdated = themeManager.fetchTheme(withName: "Just math")!
        
        XCTAssertEqual(themeUpdated.unwrappedName, "Just math")
        
    }
}
