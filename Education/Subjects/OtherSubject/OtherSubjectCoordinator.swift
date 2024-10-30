//
//  OtherSubjectCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 03/09/24.
//

import UIKit

class OtherSubjectCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController
    private let viewModel: StudyTimeViewModel

    init(navigationController: UINavigationController, viewModel: StudyTimeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let viewController = OtherSubjectViewController(viewModel: viewModel)
        viewController.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: viewController)

        if let studyTimeCoordinator = parentCoordinator as? StudyTimeCoordinator {
            newNavigationController.transitioningDelegate = studyTimeCoordinator
        }

        newNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(newNavigationController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
