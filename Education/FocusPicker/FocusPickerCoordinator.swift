//
//  FocusPickerCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FocusPickerViewModel()
        let vc = FocusPickerViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
