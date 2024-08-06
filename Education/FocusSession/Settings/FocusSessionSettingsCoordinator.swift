//
//  FocusSessionSettingsCoordinator.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class FocusSessionSettingsCoordinator: NSObject, Coordinator, ShowingTimer, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.navigationController.delegate = self
        self.navigationController.navigationBar.prefersLargeTitles = true
        
        let viewModel = FocusSessionSettingsViewModel()
        let vc = FocusSessionSettingsViewController(viewModel: viewModel)
        vc.coordinator = self
        vc.title = String(localized: "newFocusSession")
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showTimer(totalTimeInSeconds: Int, subject: Subject?, timerCase: TimerCase) {
//        let child = FocusSessionCoordinator(navigationController: self.navigationController, totalTimeInSeconds: totalTimeInSeconds, subject: subject, timerCase: timerCase)
//        child.parentCoordinator = self
//        self.childCoordinators.append(child)
//        child.start()
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
        
        if let timerViewController = fromViewController as? FocusSessionViewController {
            self.childDidFinish(timerViewController.coordinator as? Coordinator)
        }
    }
}
