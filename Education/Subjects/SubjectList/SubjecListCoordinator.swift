//
//  SubjectlistCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 19/08/24.
//

import UIKit


class SubjectListCoordinator: NSObject, Coordinator, ShowingSubjectCreation, Dismissing{
    
    
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
        let vc = SubjectListViewController(viewModel: self.viewModel)
        vc.coordinator = self
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        
        if let studyTimeCoordinator = self.parentCoordinator as? StudyTimeCoordinator {
            self.newNavigationController.transitioningDelegate = studyTimeCoordinator
        }
        
        self.newNavigationController.modalPresentationStyle = .pageSheet
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: self.newNavigationController, viewModel: viewModel)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}

extension SubjectListCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let nav = dismissed as? UINavigationController else { return nil}
        
        if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationController {
            self.childDidFinish(subjectCreationVC.coordinator as? Coordinator)
            
            subjectCreationVC.viewModel.fetchSubjects()
        }
        
        return nil
    }
}
