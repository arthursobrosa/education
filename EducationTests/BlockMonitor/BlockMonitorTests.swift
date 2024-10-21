//
//  BlockMonitorTests.swift
//  EducationTests
//
//  Created by Arthur Sobrosa on 21/10/24.
//

import XCTest
import FamilyControls
@testable import Education

final class MockBlockAppsMonitor: BlockingManager {
    static let appsKey = "applicationsTest"
    
    var selectionToDiscourage: FamilyActivitySelection
    var mockSelectionToDiscourage: MockFamilyActivitySelection {
        didSet {
            do {
                let encoded = try JSONEncoder().encode(mockSelectionToDiscourage)
                UserDefaults.standard.set(encoded, forKey: Self.appsKey)
            } catch {
                print("error to encode data: \(error)")
            }
        }
    }
    
    var store = MockManagedSettingsStore()
    var isBlocked = false
    var isCreatingBlockAppsNotification = false
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: Self.appsKey) {
            do {
                let decodedSelection = try JSONDecoder().decode(MockFamilyActivitySelection.self, from: savedData)
                mockSelectionToDiscourage = decodedSelection
            } catch {
                print("error to decode data: \(error)")
                mockSelectionToDiscourage = MockFamilyActivitySelection()
            }
        } else {
            mockSelectionToDiscourage = MockFamilyActivitySelection()
        }
        
        selectionToDiscourage = FamilyActivitySelection()
    }
    
    func applyShields() {
        do {
            guard let data = UserDefaults.standard.data(forKey: Self.appsKey) else { return }
            let decoded = try JSONDecoder().decode(MockFamilyActivitySelection.self, from: data)
            
            let applications = decoded.applicationTokens
            let categories = decoded.categoryTokens
            
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = categories.isEmpty ? nil : categories
        } catch {
            print("error to decode: \(error)")
        }
        
        isBlocked = true
        isCreatingBlockAppsNotification = true
    }
    
    func removeShields() {
        guard isBlocked else { return }
        
        store.shield.applications =  nil
        store.shield.applicationCategories = nil
        
        isBlocked = false
        isCreatingBlockAppsNotification = false
    }
}

struct MockFamilyActivitySelection: Codable, Equatable {
    var applicationTokens: Set<String>
    var categoryTokens: Set<String>
    
    init(applicationTokens: Set<String> = [], categoryTokens: Set<String> = []) {
        self.applicationTokens = applicationTokens
        self.categoryTokens = categoryTokens
    }
}

struct MockManagedSettingsStore {
    var shield: MockShield
    
    struct MockShield {
        var applications: Set<String>?
        var applicationCategories: Set<String>?
    }
    
    init(shield: MockShield = MockShield()) {
        self.shield = shield
    }
}

class BlockMonitorTests: XCTestCase {
    func testInitWithSavedData() {
        // Arrange
        var testSelection = MockFamilyActivitySelection()
        testSelection.categoryTokens = ["games", "social"]
        let encodedData = try? JSONEncoder().encode(testSelection)
        UserDefaults.standard.set(encodedData, forKey: MockBlockAppsMonitor.appsKey)
        
        // Act
        let monitor = MockBlockAppsMonitor()
        
        // Assert
        let decodedData = UserDefaults.standard.data(forKey: MockBlockAppsMonitor.appsKey)
        XCTAssertNotNil(decodedData)
        XCTAssertEqual(monitor.mockSelectionToDiscourage, testSelection)
    }
    
    func testInitializationWithoutSavedData() {
        // Act
        UserDefaults.standard.removeObject(forKey: MockBlockAppsMonitor.appsKey)

        // Assert
        let decodedData = UserDefaults.standard.data(forKey: MockBlockAppsMonitor.appsKey)
        XCTAssertNil(decodedData)
    }
    
    func testSelectionToDiscourageSaving() {
        // Arrange
        let monitor = MockBlockAppsMonitor()
        let newSelection = MockFamilyActivitySelection(applicationTokens: ["X", "Zapperson"], categoryTokens: ["Seila"])
        monitor.mockSelectionToDiscourage = newSelection

        // Act
        if let savedData = UserDefaults.standard.data(forKey: MockBlockAppsMonitor.appsKey) {
            let decodedSelection = try? JSONDecoder().decode(MockFamilyActivitySelection.self, from: savedData)
            // Assert
            XCTAssertEqual(decodedSelection, newSelection)
        } else {
            // Assert
            XCTFail("No data found in UserDefaults")
        }
    }
    
    func testApplyShields_withTokens() {
        // Arrange
        var testSelection = MockFamilyActivitySelection()
        testSelection.applicationTokens = ["foo", "bar"]
        testSelection.categoryTokens = ["games", "social"]
        let encodedData = try? JSONEncoder().encode(testSelection)
        UserDefaults.standard.set(encodedData, forKey: MockBlockAppsMonitor.appsKey)
        
        // Act
        let monitor = MockBlockAppsMonitor()
        monitor.applyShields()
        
        // Assert
        XCTAssertEqual(monitor.isBlocked, true)
        XCTAssertEqual(monitor.store.shield.applications, testSelection.applicationTokens)
        XCTAssertEqual(monitor.store.shield.applicationCategories, testSelection.categoryTokens)
    }
    
    func testApplyShields_withoutTokens() {
        // Arrange
        var testSelection = MockFamilyActivitySelection()
        let encodedData = try? JSONEncoder().encode(testSelection)
        UserDefaults.standard.set(encodedData, forKey: MockBlockAppsMonitor.appsKey)
        
        // Act
        let monitor = MockBlockAppsMonitor()
        monitor.applyShields()
        
        // Assert
        XCTAssertNil(monitor.store.shield.applications)
        XCTAssertNil(monitor.store.shield.applicationCategories)
        XCTAssertEqual(monitor.isBlocked, true)
        XCTAssertEqual(monitor.isCreatingBlockAppsNotification, true)
    }
    
    func testRemoveShields() {
        // Arrange
        let monitor = MockBlockAppsMonitor()
        monitor.store.shield.applications = ["foo", "bar"]
        monitor.store.shield.applicationCategories = ["X"]
        monitor.isBlocked = true
        monitor.isCreatingBlockAppsNotification = true
        
        // Act
        monitor.removeShields()
        
        // Assert
        XCTAssertNil(monitor.store.shield.applications)
        XCTAssertNil(monitor.store.shield.applicationCategories)
        XCTAssertEqual(monitor.isCreatingBlockAppsNotification, false)
    }
}
