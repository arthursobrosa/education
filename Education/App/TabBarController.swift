//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    private var themeList = ThemeListCoordinator(navigationController: UINavigationController())
    private var timerSettings = FocusSessionSettingsCoordinator(navigationController: UINavigationController())
    private var studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: "Themes", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
        timerSettings.start()
        timerSettings.navigationController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), tag: 2)
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: "Study Time", image: UIImage(systemName: "calendar.badge.clock"), tag: 3)
        
        self.viewControllers = [themeList.navigationController, timerSettings.navigationController, studytime.navigationController]
        
        self.view.backgroundColor = .systemBackground
    }
}

