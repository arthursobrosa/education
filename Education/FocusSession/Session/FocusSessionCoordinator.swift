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
    var subjectID: String?
    var timerCase: TimerCase
    
    init(navigationController: UINavigationController, totalTimeInSeconds: Int, subjectID: String?, timerCase: TimerCase) {
        self.navigationController = navigationController
        self.totalTimeInSeconds = totalTimeInSeconds
        self.subjectID = subjectID
        self.timerCase = timerCase
    }
    
    func start() {
        let viewModel = FocusSessionViewModel(totalSeconds: self.totalTimeInSeconds, subjectID: self.subjectID, timerCase: self.timerCase)
        let vc = FocusSessionViewController(viewModel: viewModel)
        vc.title = String(localized: "focusSession")
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
