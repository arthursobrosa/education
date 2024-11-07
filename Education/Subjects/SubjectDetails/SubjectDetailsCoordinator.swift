//
//  SubjectDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class SubjectDetailsCoordinator: NSObject, Coordinator, Dismissing, ShowingFocusSubjectDetails {
    
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
    
    func showFocusSubjectDetails(focusSession: FocusSession) {
        let vm = FocusSubjectDetailsViewModel(focusSession: focusSession)
        let child = FocusSubjectDetailsCoordinator(navigationController: navigationController, viewModel: vm)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}

extension SubjectDetailsCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        guard let nav = dismissed as? UINavigationController else { return nil }
        
        if let focusSubjectDetailsVC = nav.viewControllers.first as? FocusSubjectDetailsViewController {
            childDidFinish(focusSubjectDetailsVC.coordinator as? Coordinator)
            
            if let subjectDetailVC = navigationController.viewControllers.first as? SubjectDetailsViewController {
                subjectDetailVC.reloadInputViews()
            }
        }
        
        return nil
    }
}
