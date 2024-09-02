//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Coordinators
    let schedule = ScheduleCoordinator(navigationController: UINavigationController())
    private let studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    private let themeList = ThemeListCoordinator(navigationController: UINavigationController())
    let settings = SettingsCoordinator(navigationController: UINavigationController())
    
    // MARK: - Live activity view
    lazy var activityView: ActivityView = {
        let view = ActivityView()
        view.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activityViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    // MARK: - Custom TabBar
    private let customTabBar = CustomTabBar()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ActivityManager.shared.delegate = self
        
        self.setValue(self.customTabBar, forKey: "tabBar")
        self.setTabItems()
        self.startCoordinators()
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnMedium, size: 10)!
        ]
        self.tabBar.backgroundColor = .systemBackground
        
        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTab"), image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
        schedule.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        schedule.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: String(localized: "subjectTab"), image: UIImage(systemName: "books.vertical"), tag: 1)
        studytime.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        studytime.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: String(localized: "themeTab"), image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
        themeList.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        themeList.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        settings.start()
        settings.navigationController.tabBarItem = UITabBarItem(title: String(localized: "settingsTab"), image: UIImage(systemName: "gearshape"), tag: 3)
        settings.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        settings.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        self.viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, settings.navigationController]
    }
    
    private func setTabItems() {
        schedule.navigationController.tabBarItem = UITabBarItem(title: TabCase.schedule.title, image: TabCase.schedule.image, tag: TabCase.schedule.rawValue)
        studytime.navigationController.tabBarItem = UITabBarItem(title: TabCase.subjects.title, image: TabCase.subjects.image, tag: TabCase.subjects.rawValue)
        themeList.navigationController.tabBarItem = UITabBarItem(title: TabCase.exams.title, image: TabCase.exams.image, tag: TabCase.exams.rawValue)
        settings.navigationController.tabBarItem = UITabBarItem(title: TabCase.settings.title, image: TabCase.settings.image, tag: TabCase.settings.rawValue)
    }
    
    private func startCoordinators() {
        schedule.start()
        studytime.start()
        themeList.start()
        settings.start()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.view.bounds.width * (366/390)
        let height = width * (60/366)
        let lateralPadding = (self.view.bounds.width - width) / 2
        
        self.activityView.frame = CGRect(x: lateralPadding, y: self.view.bounds.height - self.tabBar.frame.height - (height + 15), width: width, height: height)
        self.customTabBar.frame = CGRect(x: 0, y: self.view.bounds.height - self.customTabBar.frame.height, width: self.view.bounds.width, height: self.view.bounds.height * (65/844))
    }
    
    @objc func activityViewTapped() {
        self.selectedIndex = self.schedule.navigationController.tabBarItem.tag
        
        self.schedule.showTimer(focusSessionModel: nil)
    }
}

enum TabCase: Int {
    case schedule = 0
    case subjects = 1
    case exams = 2
    case settings = 3
    
    var title: String {
        switch self {
            case .schedule:
                return String(localized: "scheduleTab")
            case .subjects:
                return String(localized: "subjectTab")
            case .exams:
                return String(localized: "themeTab")
            case .settings:
                return String(localized: "settingsTab")
        }
    }
    
    var image: UIImage? {
        var caseImage: UIImage?
        
        switch self {
            case .schedule:
                caseImage = UIImage(systemName: "calendar.badge.clock")
            case .subjects:
                caseImage = UIImage(systemName: "books.vertical")
            case .exams:
                caseImage = UIImage(systemName: "list.bullet.clipboard")
            case .settings:
                caseImage = UIImage(systemName: "gearshape")
        }
        
        return caseImage?.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 18)))
    }
}
