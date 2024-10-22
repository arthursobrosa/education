//
//  TabBarViewModel.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/10/24.
//

import UIKit

class TabBarViewModel {
    let activityManager: ActivityManager
    let blockingManager: BlockingManager
    let notificationService: NotificationProtocol?
    
    init(activityManager: ActivityManager, blockingManager: BlockingManager, notificationService: NotificationProtocol?) {
        self.activityManager = activityManager
        self.blockingManager = blockingManager
        self.notificationService = notificationService
    }
}
