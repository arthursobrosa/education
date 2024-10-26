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
    private var newNavigationController = UINavigationController()
    private let viewModel: StudyTimeViewModel

    init(navigationController: UINavigationController, viewModel: StudyTimeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let vc = OtherSubjectViewController(viewModel: viewModel)
        vc.coordinator = self

        newNavigationController = UINavigationController(rootViewController: vc)

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
