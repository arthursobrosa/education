//
//  TimerCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TimerCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var totalTimeInMinutes: Int
    
    init(navigationController: UINavigationController, totalTimeInMinutes: Int) {
        self.navigationController = navigationController
        self.totalTimeInMinutes = totalTimeInMinutes
    }
    
    func start() {
        let viewModel = TimerViewModel(timerStart: Date(), totalTimeInMinutes: 2)
        let vc = TimerViewController(totalTimeInMinutes: self.totalTimeInMinutes, viewModel: viewModel)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}
