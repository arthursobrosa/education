//
//  SplashCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/07/24.
//

import UIKit

class SplashCoordinator: Coordinator, ShowingTabBar {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let activityManager: ActivityManager
    private let blockingManager: BlockingManager
    private let notificationService: NotificationServiceProtocol?

    struct ScheduleNotification {
        var subjectName: String
        var startTime: Date
        var endTime: Date
    }

    var scheduleNotification: ScheduleNotification?

    init(navigationController: UINavigationController, activityManager: ActivityManager?, blockingManager: BlockingManager?, notificationService: NotificationServiceProtocol?) {
        self.navigationController = navigationController
        self.notificationService = notificationService
        self.activityManager = activityManager ?? ActivityManager(notificationService: notificationService)
        self.blockingManager = blockingManager ?? BlockAppsMonitor()
    }

    func start() {
        let viewModel = SplashViewModel()
        let viewController = SplashViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: false)
    }

    func showTabBar() {
        let viewModel = TabBarViewModel(activityManager: activityManager, blockingManager: blockingManager, notificationService: notificationService)
        let tabBar = TabBarController(viewModel: viewModel)
        tabBar.modalPresentationStyle = .fullScreen

        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabBar, animated: false)

        guard let scheduleNotification else { return }

        tabBar.selectedIndex = 0
        tabBar.schedule.showScheduleNotification(subjectName: scheduleNotification.subjectName, startTime: scheduleNotification.startTime, endTime: scheduleNotification.endTime)

        self.scheduleNotification = nil
    }
}
