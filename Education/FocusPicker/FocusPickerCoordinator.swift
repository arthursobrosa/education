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
    var timerCase: TimerCase?
    
    init(navigationController: UINavigationController, timerCase: TimerCase?) {
        self.navigationController = navigationController
        self.timerCase = timerCase
    }
    
    func start() {
        let viewModel = FocusPickerViewModel(timerCase: self.timerCase)
        let vc = FocusPickerViewController(viewModel: viewModel)
        vc.coordinator = self
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
