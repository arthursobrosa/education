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
    
    init(activityManager: ActivityManager, blockingManager: BlockingManager) {
        self.activityManager = activityManager
        self.blockingManager = blockingManager
    }
}
