//
//  ThemeListCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemeListCoordinator: NSObject, Coordinator, ShowingThemePage, ShowingNewTheme, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.delegate = self
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let viewModel = ThemeListViewModel()
        let vc = ThemeListViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showThemePage(theme: Theme) {
        let child = ThemePageCoordinator(navigationController: self.navigationController, theme: theme)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showNewTheme(viewModel: ThemeListViewModel) {
        let child = NewThemeCoordinator(navigationController: self.navigationController, viewModel: viewModel)
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

extension ThemeListCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }
        
        if let newThemeVC = nav.viewControllers.first as? NewThemeViewController {
            self.childDidFinish(newThemeVC.coordinator as? Coordinator)
            
            if let themeListVC = self.navigationController.viewControllers.first as? ThemeListViewController {
                themeListVC.reloadTable()
            }
        }
        
        return nil
    }
}
