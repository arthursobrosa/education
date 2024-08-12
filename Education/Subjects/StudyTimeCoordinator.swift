//
//  StudyTimeCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 10/07/24.
//

import UIKit

class StudyTimeCoordinator: Coordinator {
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
}
