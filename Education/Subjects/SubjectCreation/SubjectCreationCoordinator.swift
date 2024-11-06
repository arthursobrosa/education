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
    private let viewModel: StudyTimeViewModel

    init(navigationController: UINavigationController, viewModel: StudyTimeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let viewController = SubjectCreationViewController(viewModel: viewModel)
        viewController.coordinator = self

        let newNavigationController = UINavigationController(rootViewController: viewController)

        if let studyTimeCoordinator = parentCoordinator as? StudyTimeCoordinator {
            newNavigationController.transitioningDelegate = studyTimeCoordinator
        }

        if let scheduleCoordinator = parentCoordinator as? ScheduleCoordinator {
            newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        if let scheduleDetailsCoordinator = parentCoordinator as? ScheduleDetailsCoordinator {
            newNavigationController.transitioningDelegate = scheduleDetailsCoordinator
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
