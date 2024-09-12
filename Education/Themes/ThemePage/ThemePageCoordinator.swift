//
//  ThemePageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemePageCoordinator: NSObject, Coordinator, ShowingTestPage, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var theme: Theme
    
    init(navigationController: UINavigationController, theme: Theme) {
        self.navigationController = navigationController
        self.theme = theme
    }
    
    func start() {
        let viewModel = ThemePageViewModel(theme: self.theme)
        let vc = ThemePageViewController(viewModel: viewModel)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showTestPage(theme: Theme, test: Test?) {
        let child = TestPageCoordinator(navigationController: self.navigationController, theme: theme, test: test)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension ThemePageCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }
        
        if let testPageVC = nav.viewControllers.first as? TestPageViewController {
            self.childDidFinish(testPageVC.coordinator as? Coordinator)
            
            if let themePageVC = self.navigationController.viewControllers.last as? ThemePageViewController {
                themePageVC.viewModel.fetchTests()
            }
        }
        
        return nil
    }
}
