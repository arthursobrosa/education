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
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let viewModel = StudyTimeViewModel()
        let vc = StudyTimeViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showSubjectCreation(viewModel: StudyTimeViewModel) {
        let child = SubjectCreationCoordinator(navigationController: self.navigationController, viewModel: viewModel)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showOtherSubject(viewModel: StudyTimeViewModel) {
        let child = OtherSubjectCoordinator(navigationController: self.navigationController, viewModel: viewModel)
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
}

extension StudyTimeCoordinator: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let nav = dismissed as? UINavigationController else { return nil}
        
        if let subjectCreationVC = nav.viewControllers.first as? SubjectCreationViewController {
            self.childDidFinish(subjectCreationVC.coordinator as? Coordinator)
        
            subjectCreationVC.viewModel.fetchSubjects()
            subjectCreationVC.viewModel.fetchFocusSessions()
            
            if subjectCreationVC.viewModel.currentEditingSubject != nil {
                subjectCreationVC.viewModel.currentEditingSubject = nil
            }
            
            subjectCreationVC.viewModel.selectedSubjectColor.value = subjectCreationVC.viewModel.subjectColors[0]
            
            if let studyTimeVC = self.navigationController.viewControllers.first as? StudyTimeViewController {
                studyTimeVC.reloadTable()
            }
        }
        
        if let otherSubjectVC = nav.viewControllers.first as? OtherSubjectViewController {
            self.childDidFinish(otherSubjectVC.coordinator as? Coordinator)
        
            otherSubjectVC.viewModel.fetchSubjects()
            otherSubjectVC.viewModel.fetchFocusSessions()
            
            if let studyTimeVC = self.navigationController.viewControllers.first as? StudyTimeViewController {
                studyTimeVC.reloadTable()
            }
        }
        
        return nil
    }
}
