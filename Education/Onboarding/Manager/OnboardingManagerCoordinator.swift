//
//  OnboardingManagerCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 14/11/24.
//

import UIKit

class OnboardingManagerCoordinator: Coordinator, ShowingTabBar {
    var childCoordinators: [Coordinator] = []
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
        let onboarding1 = Onboarding1ViewController()
        let onboarding2 = Onboarding2ViewController()
        let onboarding3 = Onboarding3ViewController()
        
        let pages: [UIViewController] = [
            onboarding1,
            onboarding2,
            onboarding3,
        ]
        
        let onboardingManager = OnboardingManagerViewController(pages: pages)
        onboardingManager.coordinator = self
        onboarding1.delegate = onboardingManager
        onboarding2.delegate = onboardingManager
        onboarding3.delegate = onboardingManager
        
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.pushViewController(onboardingManager, animated: true)
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
