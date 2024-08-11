//
//  ThemeListCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemeListCoordinator: NSObject, Coordinator, ShowingThemePage, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let themeListViewModel: ThemeListViewModel
    
    init(navigationController: UINavigationController, themeListViewModel: ThemeListViewModel) {
        self.navigationController = navigationController
        self.themeListViewModel = themeListViewModel
    }
    
    func start() {
        self.navigationController.delegate = self
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let vc = ThemeListViewController(viewModel: self.themeListViewModel)
        vc.title = String(localized: "themeTab")
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showThemePage(theme: Theme) {
        let child = ThemePageCoordinator(navigationController: self.navigationController, theme: theme)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = self.navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if self.navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let themePageViewController = fromViewController as? ThemePageViewController {
            self.childDidFinish(themePageViewController.coordinator as? Coordinator)
        }
    }
}
