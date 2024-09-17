//
//  SettingsViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 07/08/24.
//

import Foundation

class SettingsViewModel {
    let days = [
        String(localized: "sunday"),
        String(localized: "monday"),
        String(localized: "tuesday"),
        String(localized: "wednesday"),
        String(localized: "thursday"),
        String(localized: "friday"),
        String(localized: "saturday")
    ]
    lazy var selectedDay: String = self.days[UserDefaults.dayOfWeek]
    
    var isNotificationActive = Box(false)
    
    func requestNoficationAuthorization() {
        NotificationService.shared.requestAuthorization { [weak self] granted, error in
            guard let self else { return }
            
            if let error {
                print(error.localizedDescription)
                return
            }
            
            self.isNotificationActive.value = granted
        }
    }
}

enum SettingsCase: CaseIterable {
    case notifications
    case blockApps
    case firstWeekDay
    
    var title: String {
        switch self {
            case .notifications:
                return String(localized: "notificationsAndAlerts")
            case .blockApps:
                return String(localized: "blockApps")
            case .firstWeekDay:
                return String(localized: "firstWeekDay")
        }
    }
    
    var iconName: String {
        switch self {
            case .notifications:
                return "bell.badge"
            case .blockApps:
                return "lock.badge.clock"
            case .firstWeekDay:
                return "calendar"
        }
    }
}
