//
//  TestPageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import UIKit

class TestPageCoordinator: Coordinator, Dismissing, DismissingAll {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var isRemovingTest: Bool = false

    private let theme: Theme
    private let test: Test?

    init(navigationController: UINavigationController, theme: Theme, test: Test?) {
        self.navigationController = navigationController
        self.theme = theme
        self.test = test
    }

    func start() {
        let viewModel = TestPageViewModel(theme: theme, test: test)
        let viewController = TestPageViewController(viewModel: viewModel)
        viewController.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: viewController)

        if let themePageCoordinator = parentCoordinator as? ThemePageCoordinator {
            newNavigationController.transitioningDelegate = themePageCoordinator
        }

        if let testDetailsCoordinator = parentCoordinator as? TestDetailsCoordinator {
            newNavigationController.transitioningDelegate = testDetailsCoordinator
        }

        newNavigationController.modalPresentationStyle = .pageSheet

        navigationController.present(newNavigationController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }

    func dismissAll() {
        isRemovingTest = true
        dismiss(animated: true)

        if let testDetailsCoordinator = parentCoordinator as? TestDetailsCoordinator {
            testDetailsCoordinator.dismiss(animated: false)
        }
    }
}
