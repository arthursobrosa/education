//
//  SubjectDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class SubjectDetailsCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController
    private let viewModel: SubjectDetailsViewModel

    init(navigationController: UINavigationController, viewModel: SubjectDetailsViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {

        let viewController = SubjectDetailsViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
