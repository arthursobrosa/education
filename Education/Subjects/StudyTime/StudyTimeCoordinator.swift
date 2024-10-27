//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeCoordinator: NSObject, Coordinator, ShowingSubjectCreation, ShowingOtherSubject {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.navigationBar.prefersLargeTitles = true

        let viewModel = StudyTimeViewModel()
        let viewController = StudyTimeViewController(viewModel: viewModel)
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: false)
    }

    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func showOtherSubject(viewModel: StudyTimeViewModel) {
        let child = OtherSubjectCoordinator(navigationController: navigationController, viewModel: viewModel)
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

extension StudyTimeCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let nav = dismissed as? UINavigationController else { return nil }

        if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationViewController {
            childDidFinish(subjectCreationVC.coordinator as? Coordinator)

            subjectCreationVC.viewModel.fetchSubjects()
            subjectCreationVC.viewModel.fetchFocusSessions()

            if subjectCreationVC.viewModel.currentEditingSubject != nil {
                subjectCreationVC.viewModel.currentEditingSubject = nil
            }

            subjectCreationVC.viewModel.selectedSubjectColor.value = subjectCreationVC.viewModel.selectAvailableColor()

            if let studyTimeVC = navigationController.viewControllers.first as? StudyTimeViewController {
                studyTimeVC.reloadTable()
            }
        }

        if let otherSubjectVC = nav.viewControllers.first as? OtherSubjectViewController {
            childDidFinish(otherSubjectVC.coordinator as? Coordinator)

            otherSubjectVC.viewModel.fetchSubjects()
            otherSubjectVC.viewModel.fetchFocusSessions()

            if let studyTimeVC = navigationController.viewControllers.first as? StudyTimeViewController {
                studyTimeVC.reloadTable()
            }
        }

        return nil
    }
}
