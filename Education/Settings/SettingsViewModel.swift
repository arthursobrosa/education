//
//  SettingsViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 07/08/24.
//

import Foundation

class SettingsViewModel {
    func requestNoficationAuthorization() {
        NotificationService.shared.requestAuthorization { granted, error in
            if granted {
                print("notification persimission granted")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}
