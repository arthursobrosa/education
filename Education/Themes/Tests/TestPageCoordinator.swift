//
//  TestPageCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/09/24.
//

import UIKit

class TestPageCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let theme: Theme
    
    init(navigationController: UINavigationController, theme: Theme) {
        self.navigationController = navigationController
        self.theme = theme
    }
    
    func start() {
        let viewModel = TestPageViewModel(theme: self.theme)
        let vc = TestPageViewController(viewModel: viewModel)
        vc.coordinator = self
        
        let newNavigationController = UINavigationController(rootViewController: vc)
        
        if let themePageCoordinator = self.parentCoordinator as? ThemePageCoordinator {
            newNavigationController.transitioningDelegate = themePageCoordinator
        }
        
        newNavigationController.modalPresentationStyle = .pageSheet
        
        self.navigationController.present(newNavigationController, animated: true)
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}
