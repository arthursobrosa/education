//
//  SubjectDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class SubjectDetailsCoordinator: NSObject, Coordinator, Dismissing, ShowingSubjectCreation, ShowingFocusSubjectDetails {
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

    func showFocusSubjectDetails(focusSession: FocusSession) {
        let viewModel = FocusSubjectDetailsViewModel(focusSession: focusSession)
        let child = FocusSubjectDetailsCoordinator(navigationController: navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.popViewController(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension SubjectDetailsCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let nav = dismissed as? UINavigationController {
            if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationViewController {
                childDidFinish(subjectCreationVC.coordinator as? Coordinator)

                if let subjectDetailsVC = navigationController.viewControllers.last as? SubjectDetailsViewController {
                    subjectDetailsVC.viewModel.updateSubject()
                    
                    if subjectDetailsVC.viewModel.wasSubjectDeleted {
                        dismiss(animated: true)
                        return nil
                    }
                    
                    subjectDetailsVC.setNavigationItems()
                    subjectDetailsVC.reloadTable()
                }
            }
        } else {
            if let focusSubjectDetailsVC = dismissed as? FocusSubjectDetailsViewController {
                childDidFinish(focusSubjectDetailsVC.coordinator as? Coordinator)
                
                if let subjectDetailVC = navigationController.viewControllers.last as? SubjectDetailsViewController {
                    subjectDetailVC.viewModel.updateSubject()
                    subjectDetailVC.setNavigationItems()
                    subjectDetailVC.reloadTable()
                }
            }
        }

        return nil
    }
}
