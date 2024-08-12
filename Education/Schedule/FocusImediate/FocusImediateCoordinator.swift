//
//  FocusImediateCoordinator.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateCoordinator: Coordinator, ShowingFocusSelection, Dismissing {
    weak var parentCoordinator: ScheduleCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FocusImediateViewModel()
        let vc = FocusImediateViewController(viewModel: viewModel, color: UIColor(named: "defaultColor"))
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFocusSelection(color: UIColor?, subject: Subject?, blocksApps: Bool) {
        let child = FocusSelectionCoordinator(navigationController: self.navigationController, color: color, subject: subject, blocksApps: blocksApps)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
}
