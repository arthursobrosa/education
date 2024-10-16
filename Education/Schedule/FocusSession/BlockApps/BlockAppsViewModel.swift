//
//  BlockAppsMonitor.swift
//  Education
//
//  Created by Lucas Cunha on 10/07/24.
//

import FamilyControls
import ManagedSettingsUI
import ManagedSettings
import DeviceActivity
import SwiftUI

protocol BlockingManager {
    var selectionToDiscourage: FamilyActivitySelection { get set }
    
    func requestAuthorization()
    func applyShields()
    func removeShields()
    func monitorSchedule()
}

class BlockAppsMonitor: ObservableObject, BlockingManager {
    let store = ManagedSettingsStore()
    let center = AuthorizationCenter.shared
    private var isBlocked = false
    
    func requestAuthorization() {
        let isAuthorized = center.authorizationStatus.description
        print(isAuthorized)
    }
    
    func applyShields() {
        do {
            guard let data = UserDefaults.standard.data(forKey: "applications") else { return }
            let decoded = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            
            let applications = decoded.applicationTokens
            let categories = decoded.categoryTokens
            
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        } catch {
            print("error to decode: \(error)")
        }
        
        isBlocked = true
        createBlockAppsNotification(isStarting: true)
    }
    
    func removeShields() {
        guard isBlocked else { return }
        
        store.shield.applications =  nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        
        isBlocked = false
        createBlockAppsNotification(isStarting: false)
    }
    
    private func createBlockAppsNotification(isStarting: Bool) {
        let content = UNMutableNotificationContent()
        content.title = isStarting ? String(localized: "startBlockAlertTitle") : String(localized: "endBlockAlertTitle")
        content.body = isStarting ? String(localized: "startBlockAlertBody") : String(localized: "endBlockAlertBody")
        content.categoryIdentifier = "alarm"
        
        let identifier = isStarting ? "start" : "end"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    @Published var selectionToDiscourage: FamilyActivitySelection {
        didSet {
            do {
                let encoded = try JSONEncoder().encode(selectionToDiscourage)
                UserDefaults.standard.set(encoded, forKey: "applications")
                print("saved selection")
            } catch {
                print("error to encode data: \(error)")
            }
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "applications") {
            do {
                let decodedSelection = try JSONDecoder().decode(FamilyActivitySelection.self, from: savedData)
                self.selectionToDiscourage = decodedSelection
            } catch {
                print("error to decode data: \(error)")
                self.selectionToDiscourage = FamilyActivitySelection()
            }
        } else {
            self.selectionToDiscourage = FamilyActivitySelection()
        }
    }
    
    func monitorSchedule() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 15, minute: 19),
            intervalEnd: DateComponents(hour: 15, minute: 55),
            repeats: true,
            warningTime: nil
        )
        
        print("Schedule set: \(schedule)")
        
        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule)
            print("Monitoring started")
            print(schedule)
        } catch {
            print("Error starting monitoring: \(error.localizedDescription)")
        }
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}

class Observer: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.notification.request.identifier {
            case "start":
                NotificationCenter.default.post(name: Notification.Name("start"), object: nil)
            case "end":
                NotificationCenter.default.post(name: Notification.Name("end"), object: nil)
            default:
                break
        }
        
        completionHandler()
    }
}
