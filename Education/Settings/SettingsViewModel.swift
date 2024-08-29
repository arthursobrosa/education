//
//  SettingsViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 07/08/24.
//

import Foundation

class SettingsViewModel {
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
