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
    
    struct ScheduleNotification {
        var subjectName: String
        var startTime: Date
        var endTime: Date
    }
    
    var scheduleNotification: ScheduleNotification?
    
    init(navigationController: UINavigationController, themeListViewModel: ThemeListViewModel) {
        self.navigationController = navigationController
        self.themeListViewModel = themeListViewModel
    }
    
    func start() {
        let vc = SplashViewController()
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showTabBar() {
        let tabBar = TabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.pushViewController(tabBar, animated: false)
        
        guard let scheduleNotification else { return }
        
        tabBar.selectedIndex = 0
        tabBar.schedule.showScheduleNotification(subjectName: scheduleNotification.subjectName, startTime: scheduleNotification.startTime, endTime: scheduleNotification.endTime)
    }
}
