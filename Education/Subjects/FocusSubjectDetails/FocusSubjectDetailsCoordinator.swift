//
//  FocusSubjectDetailsCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import UIKit

class FocusSubjectDetailsCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    private let viewModel: FocusSubjectDetailsViewModel
    
    init(navigationController: UINavigationController, viewModel: FocusSubjectDetailsViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let viewController = FocusSubjectDetailsViewController(viewModel: viewModel)
        viewController.coordinator = self
        
        if let subjectDetailsCoordinator = parentCoordinator as? SubjectDetailsCoordinator {
            viewController.transitioningDelegate = subjectDetailsCoordinator
        }
        
        navigationController.present(viewController, animated: true)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
