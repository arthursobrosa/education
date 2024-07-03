//
//  TimerSettingsCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TimerSettingsCoordinator: NSObject, Coordinator, ShowingTimer, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.delegate = self
        
        let viewModel = TimerSettingsViewModel()
        let vc = TimerSettingsViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = "Timer"
        navigationController.pushViewController(vc, animated: false)
        
    }
    
    func showTimer(_ totalTimeInMinutes: Int) {
        let child = TimerCoordinator(navigationController: self.navigationController, totalTimeInMinutes: totalTimeInMinutes)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = self.navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if self.navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let timerViewController = fromViewController as? TimerViewController {
            self.childDidFinish(timerViewController.coordinator)
        }
    }
}
