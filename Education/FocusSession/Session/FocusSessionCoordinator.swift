//
//  FocusSessionCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class FocusSessionCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var totalTimeInSeconds: Int
    var subject: Subject?
    var timerCase: TimerCase
    
    init(navigationController: UINavigationController, totalTimeInSeconds: Int, subject: Subject?, timerCase: TimerCase) {
        self.navigationController = navigationController
        self.totalTimeInSeconds = totalTimeInSeconds
        self.subject = subject
        self.timerCase = timerCase
    }
    
    func start() {
        let viewModel = FocusSessionViewModel(totalSeconds: self.totalTimeInSeconds, subject: self.subject, timerCase: self.timerCase)
        let vc = FocusSessionViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
