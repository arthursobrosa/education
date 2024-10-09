//
//  TestDetailsCoordinator.swift
//  Education
//
//  Created by Eduardo Dalencon on 08/10/24.
//

import UIKit

class TestDetailsCoordinator: Coordinator, Dismissing, ShowingTestPage {
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let theme: Theme
    private let test: Test
    
    init(navigationController: UINavigationController, theme: Theme, test: Test) {
        self.navigationController = navigationController
        self.theme = theme
        self.test = test
    }
    
    func start() {
        let viewModel = TestDetailsViewModel(theme: self.theme, test: self.test)
        let vc = TestDetailsViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: true)
        
//        let newNavigationController = UINavigationController(rootViewController: vc)
//        
//        if let themePageCoordinator = self.parentCoordinator as? ThemePageCoordinator {
//            newNavigationController.transitioningDelegate = themePageCoordinator
//        }
//        
////        newNavigationController.modalPresentationStyle = .pageSheet
//        
//        self.navigationController.present(newNavigationController, animated: true)
    }
    
    func showTestPage(theme: Theme, test: Test?) {
        let child = TestPageCoordinator(navigationController: self.navigationController, theme: theme, test: test)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}

