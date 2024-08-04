//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: Coordinator, ShowingFocusPicker {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel()
        let vc = FocusSelectionViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showFocusPicker() {
        let child = FocusPickerCoordinator(navigationController: self.navigationController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
}
