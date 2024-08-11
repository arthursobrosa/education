//
//  ProfileCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ProfileViewModel()
        let vc = ProfileViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = String(localized: "profileTab")
        
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController.pushViewController(vc, animated: false)
    }
}
