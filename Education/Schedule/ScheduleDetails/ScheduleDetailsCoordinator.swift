//
//  ScheduleDetailsCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/08/24.
//

import UIKit

class ScheduleDetailsCoordinator: Coordinator, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private var newNavigationController = UINavigationController()
    
    private let schedule: Schedule?
    
    init(navigationController: UINavigationController, schedule: Schedule?) {
        self.navigationController = navigationController
        self.schedule = schedule
    }
    
    func start() {
        let viewModel = ScheduleDetailsViewModel(schedule: self.schedule)
        let vc = ScheduleDetailsViewController(viewModel: viewModel)
        vc.coordinator = self
        
        
        self.newNavigationController = UINavigationController(rootViewController: vc)
        if let scheduleCoordinator = self.parentCoordinator as? ScheduleCoordinator {
            self.newNavigationController.transitioningDelegate = scheduleCoordinator
        }
        
        self.newNavigationController.modalPresentationStyle = .pageSheet
        
        self.navigationController.present(self.newNavigationController, animated: true)
    }
    
    func dismiss(animated: Bool) {
        self.navigationController.dismiss(animated: animated)
    }
}
