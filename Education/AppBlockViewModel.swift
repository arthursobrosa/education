//
//  AppBlockViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 03/07/24.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import ManagedSettingsUI
import ScreenTime
import SwiftUI

class MyModel: ObservableObject {
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection

    init() {
        // Initialize selections with default values or empty selections
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }

    func requestAuthorization() {
        AuthorizationCenter.shared.requestAuthorization { result in
            switch result {
            case .success:
                print("Authorization successful")
            case let .failure(error):
                print("Authorization failed: \(error.localizedDescription)")
                return
            }
        }
    }

    func monitorSchedule() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )

        print(schedule)

        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: selectionToEncourage.applicationTokens,
                threshold: DateComponents(minute: 30)
            ),
        ]

        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error starting monitoring: \(error.localizedDescription)")
        }
    }
}

// Create a DeviceActivityMonitor
class MyMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        let model = MyModel()
        let applications: Set<ApplicationToken> = model.selectionToDiscourage.applicationTokens

        store.shield.applications = applications.isEmpty ? nil : applications
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        store.shield.applications = nil
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
    override func configuration(shielding _: Application) -> ShieldConfiguration {
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
    override func handle(action: ShieldAction, for _: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.close)
        @unknown default:
            return
        }
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}
