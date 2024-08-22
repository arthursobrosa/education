//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeCoordinator: NSObject, Coordinator, ShowingSubjectList {
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
        vc.title = String(localized: "subjectTab")
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showSubjectList(viewModel: StudyTimeViewModel) {
        let child = SubjectListCoordinator(navigationController: self.navigationController, viewModel: viewModel)
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
        
        if let subjectListVC = nav.viewControllers.first as? SubjectListViewController {
            self.childDidFinish(subjectListVC.coordinator as? Coordinator)
        
            subjectListVC.viewModel.fetchSubjects()
            subjectListVC.viewModel.fetchFocusSessions()
            
            if let studyTimeVC = self.navigationController.viewControllers.first as? StudyTimeViewController {
                studyTimeVC.reloadTable()
            }
        }
        
        return nil
    }
}
