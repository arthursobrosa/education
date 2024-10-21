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
    
    func applyShields()
    func removeShields()
}

class BlockAppsMonitor: ObservableObject, BlockingManager {
    static let appsKey = "applications"
    
    let store = ManagedSettingsStore()
    private var isBlocked = false
    
    func applyShields() {
        do {
            guard let data = UserDefaults.standard.data(forKey: Self.appsKey) else { return }
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
                UserDefaults.standard.set(encoded, forKey: Self.appsKey)
            } catch {
                print("error to encode data: \(error)")
            }
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: Self.appsKey) {
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
