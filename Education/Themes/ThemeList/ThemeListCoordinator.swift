//
//  ThemeListCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 28/06/24.
//

import UIKit

class ThemeListCoordinator: NSObject, Coordinator, ShowingThemePage, ShowingThemeEdition, ShowingTestPage {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        navigationController.navigationBar.prefersLargeTitles = true

        let viewModel = ThemeListViewModel()
        let viewController = ThemeListViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: false)
    }

    func showThemePage(theme: Theme) {
        let child = ThemePageCoordinator(navigationController: navigationController, theme: theme)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showThemeEdition(theme: Theme) {
        let child = ThemeEditionCoordinator(navigationController: navigationController, theme: theme)
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

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension ThemeListCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow _: UIViewController, animated _: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromVC) {
            return
        }

        if let themePageVC = fromVC as? ThemePageViewController {
            childDidFinish(themePageVC.coordinator as? Coordinator)
        }
    }
}

extension ThemeListCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        if let nav = dismissed as? UINavigationController {
            if let themeEditionVC = nav.viewControllers.first as? ThemeEditionViewController {
                childDidFinish(themeEditionVC.coordinator as? Coordinator)

                if let themeListVC = navigationController.viewControllers.first as? ThemeListViewController {
                    themeListVC.viewModel.fetchThemes()
                    themeListVC.reloadTable()
                }
            }
        } else {
            if let testPageVC = dismissed as? TestPageViewController {
                childDidFinish(testPageVC.coordinator as? Coordinator)
                
                if let themeListVC = navigationController.viewControllers.first as? ThemeListViewController {
                    themeListVC.viewModel.fetchThemes()
                    themeListVC.reloadTable()
                }
            }
        }
        
        return nil
    }
}
