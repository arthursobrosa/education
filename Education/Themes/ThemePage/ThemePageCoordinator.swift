//
//  ThemePageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemePageCoordinator: NSObject, Coordinator, ShowingTestDetails, Dismissing, ShowingTestPage {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var theme: Theme

    init(navigationController: UINavigationController, theme: Theme) {
        self.navigationController = navigationController
        self.theme = theme
    }

    func start() {
        let viewModel = ThemePageViewModel(theme: theme)
        let viewController = ThemePageViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func showTestDetails(theme: Theme, test: Test) {
        let child = TestDetailsCoordinator(navigationController: navigationController, theme: theme, test: test)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showTestPage(theme: Theme?, test: Test?) {
        let child = TestPageCoordinator(navigationController: navigationController, theme: theme, test: test)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension ThemePageCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        if let testPageVC = dismissed as? TestPageViewController {
            childDidFinish(testPageVC.coordinator as? Coordinator)

            if let themePageVC = navigationController.viewControllers.last as? ThemePageViewController {
                themePageVC.viewModel.fetchTests()
            }
        }

        return nil
    }
}
