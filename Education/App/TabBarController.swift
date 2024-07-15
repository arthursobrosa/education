//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    private let themeList = ThemeListCoordinator(navigationController: UINavigationController())
    private let timerSettings = FocusSessionSettingsCoordinator(navigationController: UINavigationController())
    private let studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    private let schedule = ScheduleCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: "Themes", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
        
        timerSettings.start()
        timerSettings.navigationController.tabBarItem = UITabBarItem(title: "Timer", image: UIImage(systemName: "timer"), tag: 2)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: "Study Time", image: UIImage(systemName: "calendar.badge.clock"), tag: 3)
        
        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: "Schedule", image: UIImage(systemName: "checklist"), tag: 4)
        
        self.viewControllers = [themeList.navigationController, timerSettings.navigationController, studytime.navigationController, schedule.navigationController]
        
        self.view.backgroundColor = .systemBackground
    }
}

