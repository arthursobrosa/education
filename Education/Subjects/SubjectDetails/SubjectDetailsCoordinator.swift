//
//  SubjectDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class SubjectDetailsCoordinator: Coordinator, Dismissing, ShowingSubjectCreation {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let subject: Subject?
    private let studyTimeViewModel: StudyTimeViewModel

    init(navigationController: UINavigationController, subject: Subject?, studyTimeViewModel: StudyTimeViewModel) {
        self.navigationController = navigationController
        self.subject = subject
        self.studyTimeViewModel = studyTimeViewModel
    }

    func start() {
        let viewModel = SubjectDetailsViewModel(subject: subject, studyTimeViewModel: studyTimeViewModel)
        let viewController = SubjectDetailsViewController(viewModel: viewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
