//
//  SubjectCreationCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 14/08/24.
//

import UIKit

class SubjectCreationCoordinator: Coordinator, Dismissing {
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
        let vc = SubjectCreationViewController(viewModel: viewModel)
        vc.coordinator = self

        newNavigationController = UINavigationController(rootViewController: vc)

        if let studyTimeCoordinator = parentCoordinator as? StudyTimeCoordinator {
            newNavigationController.transitioningDelegate = studyTimeCoordinator
        }

        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }

        newNavigationController.modalPresentationStyle = .pageSheet
        navigationController.present(newNavigationController, animated: true)
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
