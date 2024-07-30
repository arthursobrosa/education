//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    let themeListViewModel: ThemeListViewModel
    private lazy var themeList = ThemeListCoordinator(navigationController: UINavigationController(), themeListViewModel: self.themeListViewModel)
    private let timerSettings = FocusSessionSettingsCoordinator(navigationController: UINavigationController())
    private let studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    private let schedule = ScheduleCoordinator(navigationController: UINavigationController())
    
    init(themeListViewModel: ThemeListViewModel) {
        self.themeListViewModel = themeListViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: String(localized: "themesTabTitle"), image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
        
        timerSettings.start()
        timerSettings.navigationController.tabBarItem = UITabBarItem(title: String(localized: "timerTabTitle"), image: UIImage(systemName: "timer"), tag: 2)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: String(localized: "studyTimeTabTitle"), image: UIImage(systemName: "calendar.badge.clock"), tag: 3)
        
        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTabTitle"), image: UIImage(systemName: "checklist"), tag: 4)
        
        self.viewControllers = [themeList.navigationController, timerSettings.navigationController, studytime.navigationController, schedule.navigationController]
        
        self.view.backgroundColor = .systemBackground
    }
}
