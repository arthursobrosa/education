//
//  MyMonitor.swift
//  Education
//
//  Created by Lucas Cunha on 10/07/24.
//

import DeviceActivity
import ManagedSettings
import ManagedSettings

// Create a DeviceActivityMonitor
class MyMonitor: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("interval did start")
        let model = BlockAppsMonitor.shared
        let applications = model.selectionToDiscourage.applicationTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.dateAndTime.requireAutomaticDateAndTime = true
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        print("Interval ended: Clearing shield applications")
        store.shield.applications = nil
        store.dateAndTime.requireAutomaticDateAndTime = false
    }
}
