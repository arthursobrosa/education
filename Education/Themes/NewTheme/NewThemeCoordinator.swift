//
//  NewThemeCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class NewThemeCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let viewModel: ThemeListViewModel
    
    init(navigationController: UINavigationController, viewModel: ThemeListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let vc = NewThemeViewController(viewModel: self.viewModel)
        vc.coordinator = self
        
        let newNavigationController = UINavigationController(rootViewController: vc)
        
        if let themeListCoordinator = self.parentCoordinator as? ThemeListCoordinator {
            newNavigationController.transitioningDelegate = themeListCoordinator
        }
        
        newNavigationController.setNavigationBarHidden(true, animated: false)
        
        newNavigationController.modalPresentationStyle = .overFullScreen
        newNavigationController.modalTransitionStyle = .crossDissolve
        
        self.navigationController.present(newNavigationController, animated: true)
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}
