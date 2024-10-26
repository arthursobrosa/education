//
//  TestDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import UIKit

class TestDetailsCoordinator: NSObject, Coordinator, Dismissing, ShowingTestPage {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let theme: Theme
    private let test: Test

    init(navigationController: UINavigationController, theme: Theme, test: Test) {
        self.navigationController = navigationController
        self.theme = theme
        self.test = test
    }

    func start() {
        let viewModel = TestDetailsViewModel(theme: theme, test: test)
        let vc = TestDetailsViewController(viewModel: viewModel)
        vc.coordinator = self

        navigationController.pushViewController(vc, animated: true)
    }

    func showTestPage(theme: Theme, test: Test?) {
        let child = TestPageCoordinator(navigationController: navigationController, theme: theme, test: test)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.popViewController(animated: true)
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

extension TestDetailsCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let nav = dismissed as? UINavigationController else { return nil }

        if let testPageVC = nav.viewControllers.first as? TestPageViewController {
            guard let testPageCoordinator = childCoordinators.first as? TestPageCoordinator else { return nil }

            let isRemovingTest = testPageCoordinator.isRemovingTest

            childDidFinish(testPageVC.coordinator as? Coordinator)

            if let testDetailsVC = navigationController.viewControllers.last as? TestDetailsViewController {
                if !isRemovingTest {
                    testDetailsVC.viewModel.getUpdatedTest()
                    testDetailsVC.updateInterface()
                }
            }
        }

        return nil
    }
}
