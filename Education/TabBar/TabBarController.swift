//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - View Model

    let viewModel: TabBarViewModel

    // MARK: - Coordinators

    let schedule: ScheduleCoordinator
    private let studytime: StudyTimeCoordinator
    private let themeList: ThemeListCoordinator
    let settings: SettingsCoordinator

    // MARK: - Live activity view

    lazy var activityView: ActivityView = {
        let view = ActivityView()
        view.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TabBarDelegate.activityViewTapped))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    // MARK: - Custom TabBar

    private let customTabBar = CustomTabBar()

    // MARK: - Initializer

    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel

        schedule = ScheduleCoordinator(navigationController: UINavigationController(), activityManager: viewModel.activityManager, blockingManager: viewModel.blockingManager, notificationService: viewModel.notificationService)
        studytime = StudyTimeCoordinator(navigationController: UINavigationController())
        themeList = ThemeListCoordinator(navigationController: UINavigationController())
        settings = SettingsCoordinator(navigationController: UINavigationController(), blockingManager: viewModel.blockingManager, notificationService: viewModel.notificationService)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.activityManager.delegate = self

        setValue(customTabBar, forKey: "tabBar")
        setTabItems()
        startCoordinators()

        viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, settings.navigationController]
    }

    // MARK: - Methods

    private func setTabItems() {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnMedium, size: 10)!,
        ]

        schedule.navigationController.tabBarItem = UITabBarItem(title: TabCase.schedule.title, image: TabCase.schedule.image, tag: TabCase.schedule.rawValue)
        schedule.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)

        studytime.navigationController.tabBarItem = UITabBarItem(title: TabCase.subjects.title, image: TabCase.subjects.image, tag: TabCase.subjects.rawValue)
        studytime.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)

        themeList.navigationController.tabBarItem = UITabBarItem(title: TabCase.exams.title, image: TabCase.exams.image, tag: TabCase.exams.rawValue)
        themeList.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)

        settings.navigationController.tabBarItem = UITabBarItem(title: TabCase.settings.title, image: TabCase.settings.image, tag: TabCase.settings.rawValue)
        settings.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
    }

    private func startCoordinators() {
        schedule.start()
        studytime.start()
        themeList.start()
        settings.start()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let width = view.bounds.width * (366 / 390)
        let height = width * (60 / 366)
        let lateralPadding = (view.bounds.width - width) / 2

        activityView.frame = CGRect(x: lateralPadding, y: view.bounds.height - tabBar.frame.height - (height + 15), width: width, height: height)
        customTabBar.frame = CGRect(x: 0, y: view.bounds.height - customTabBar.frame.height, width: view.bounds.width, height: view.bounds.height * (65 / 844))
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

        return caseImage?.applyingSymbolConfiguration(.init(font: .systemFont(ofSize: 16)))
    }
}
