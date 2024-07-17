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
        let tabBar = TabBarController(themeListViewModel: self.themeListViewModel)
        tabBar.modalPresentationStyle = .fullScreen
        
        self.navigationController.present(tabBar, animated: false)
    }
}
