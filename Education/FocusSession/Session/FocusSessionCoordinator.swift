//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class FocusSessionCoordinator: Coordinator, Dismissing, HidingBackButton {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var totalTimeInSeconds: Int
    
    init(navigationController: UINavigationController, totalTimeInSeconds: Int) {
        self.navigationController = navigationController
        self.totalTimeInSeconds = totalTimeInSeconds
    }
    
    func start() {
        let viewModel = FocusSessionViewModel(totalSeconds: self.totalTimeInSeconds)
        let vc = FocusSessionViewController(viewModel: viewModel)
        vc.title = "Focus Session"
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
    func hideBackButton(_ isHidden: Bool) {
        self.navigationController.topViewController?.navigationItem.hidesBackButton = isHidden
    }
}
