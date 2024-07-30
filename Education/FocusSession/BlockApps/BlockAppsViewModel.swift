//
//  MyMonitor.swift
//  Education
//
//  Created by Lucas Cunha on 10/07/24.
//

import FamilyControls
import ManagedSettingsUI
import ManagedSettings
import DeviceActivity
import SwiftUI

class BlockAppsMonitor: ObservableObject {
    static let shared = BlockAppsMonitor()
    let store = ManagedSettingsStore()
    let center = AuthorizationCenter.shared
    
    func requestAuthorization() {
        let isAuthorized = center.authorizationStatus.description
        print(isAuthorized)
    }
    
    func apllyShields(){
        do {
            guard let data = UserDefaults.standard.data(forKey: "applications") else {return}
            let decoded = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            print("tudo ok \(decoded)")
            
            let applications = decoded.applicationTokens
            let categories = decoded.categoryTokens
            
            //MyShieldConfiguration().configuration(shielding: Application(token: applications.first!))
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            store.shield.webDomainCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        } catch {
            print("error to decode: \(error)")
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Ending add block"
        content.body = "🕺"
        content.categoryIdentifier = "alarm"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "end", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func removeShields(){
        store.shield.applications =  nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
    }
    
    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey:"applications")
                print("saved selection")
            } catch {
                print("error to encode data: \(error)")
            }
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
        
        //        store.dateAndTime.requireAutomaticDateAndTime = true
        //        store.account.lockAccounts = true
        //        store.passcode.lockPasscode = true
        //        store.siri.denySiri = true
        //        store.appStore.denyInAppPurchases = true
        //        store.appStore.maximumRating = 5
        //        store.appStore.requirePasswordForPurchases = true
        //        store.media.denyExplicitContent = true
        //        store.gameCenter.denyMultiplayerGaming = true
        //        store.media.denyMusicService = false
    }
}

// Implement Threshold Function
class MyMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        store.shield.applications = nil
    }
}

// Create a personalized shield
class MyShieldConfiguration: ShieldConfigurationDataSource {
    override func configuration(shielding: Application) -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .extraLight,
            backgroundColor: .blue,
            icon: UIImage(systemName: "globe"),
            title: ShieldConfiguration.Label(text: "algo", color: .green),
            subtitle: ShieldConfiguration.Label(text: "some daqui!", color: .red),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Sair", color: .blue),
            primaryButtonBackgroundColor: .cyan,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Lutar", color: .darkGray)
        )
    }
}

class MyShieldActionExtension: ShieldActionDelegate {
    override func handle(action: ShieldAction, for application: ManagedSettings.ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
            case .primaryButtonPressed:
                completionHandler(.defer)
            case .secondaryButtonPressed:
                completionHandler(.close)
            @unknown default:
                fatalError()
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

func createBlockNotification() {
    print("Firing notifications:")
    
    let content = UNMutableNotificationContent()
    content.title = "Beginning add block"
    content.body = "😱"
    content.categoryIdentifier = "alarm"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: "start", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error adding notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully")
        }
    }
}


