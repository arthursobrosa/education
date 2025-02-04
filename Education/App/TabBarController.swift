//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    let themeListViewModel: ThemeListViewModel
    let schedule = ScheduleCoordinator(navigationController: UINavigationController())
    private let studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    private lazy var themeList = ThemeListCoordinator(navigationController: UINavigationController(), themeListViewModel: self.themeListViewModel)
    private let profile = ProfileCoordinator(navigationController: UINavigationController())
//    private let timerSettings = FocusSessionSettingsCoordinator(navigationController: UINavigationController())

    init(themeListViewModel: ThemeListViewModel) {
        self.themeListViewModel = themeListViewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTabTitle"), image: UIImage(systemName: "calendar.badge.clock"), tag: 0)

        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: "Subjects", image: UIImage(systemName: "books.vertical"), tag: 1)

        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: "Exams", image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)

        profile.start()
        profile.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)

//        timerSettings.start()
//        timerSettings.navigationController.tabBarItem = UITabBarItem(title: String(localized: "timerTabTitle"), image: UIImage(systemName: "timer"), tag: 2)

        viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, profile.navigationController]

        view.backgroundColor = .systemBackground
    }
}
