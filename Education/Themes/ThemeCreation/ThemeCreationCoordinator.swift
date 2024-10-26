//
//  ThemeCreationCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeCreationCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private var theme: Theme?

    init(navigationController: UINavigationController, theme: Theme?) {
        self.navigationController = navigationController
        self.theme = theme
    }

    func start() {
        let viewModel = ThemeCreationViewModel(theme: theme)
        let vc = ThemeCreationViewController(viewModel: viewModel)
        vc.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: vc)

        if let themeListCoordinator = parentCoordinator as? ThemeListCoordinator {
            newNavigationController.transitioningDelegate = themeListCoordinator
        }

        newNavigationController.setNavigationBarHidden(true, animated: false)

        newNavigationController.modalPresentationStyle = .overFullScreen
        newNavigationController.modalTransitionStyle = .crossDissolve

        navigationController.present(newNavigationController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
