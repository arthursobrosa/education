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
    let themeListViewModel: ThemeListViewModel
    
    private let activityManager: ActivityManager
    
    struct ScheduleNotification {
        var subjectName: String
        var startTime: Date
        var endTime: Date
    }
    
    var scheduleNotification: ScheduleNotification?
    
    init(navigationController: UINavigationController, themeListViewModel: ThemeListViewModel, activityManager: ActivityManager?) {
        self.navigationController = navigationController
        self.themeListViewModel = themeListViewModel
        self.activityManager = activityManager ?? ActivityManager()
    }
    
    func start() {
        let vc = SplashViewController()
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showTabBar() {
        let viewModel = TabBarViewModel(activityManager: activityManager)
        let tabBar = TabBarController(viewModel: viewModel)
        tabBar.modalPresentationStyle = .fullScreen
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBar, animated: false)
        
        guard let scheduleNotification else { return }
        
        tabBar.selectedIndex = 0
        tabBar.schedule.showScheduleNotification(subjectName: scheduleNotification.subjectName, startTime: scheduleNotification.startTime, endTime: scheduleNotification.endTime)
        
        self.scheduleNotification = nil
    }
}
