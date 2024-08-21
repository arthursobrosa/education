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
    private var newNavigationController = UINavigationController()
    private let viewModel: StudyTimeViewModel
    
    init(navigationController: UINavigationController, viewModel: StudyTimeViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let vc = SubjectCreationController(viewModel: self.viewModel)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.popViewController(animated: animated)
    }
}
