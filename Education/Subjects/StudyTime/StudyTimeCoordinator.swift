//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeCoordinator: NSObject, Coordinator, ShowingSubjectCreation, ShowingSubjectDetails {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.delegate = self
        navigationController.setNavigationBarHidden(true, animated: false)

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
    
    func showSubjectDetails(subject: Subject?, studyTimeViewModel: StudyTimeViewModel) {
        let child = SubjectDetailsCoordinator(navigationController: navigationController, subject: subject, studyTimeViewModel: studyTimeViewModel)
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

extension StudyTimeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromVC) {
            return
        }

        if let subjectDetailsVC = fromVC as? SubjectDetailsViewController {
            childDidFinish(subjectDetailsVC.coordinator as? Coordinator)
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

        return nil
    }
}
