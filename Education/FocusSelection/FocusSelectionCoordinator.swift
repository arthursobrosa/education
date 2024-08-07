//
//  FocusSelectionCoordinator.swift
//  Education
//
//  Created by Lucas Cunha on 01/08/24.
//

import UIKit

class FocusSelectionCoordinator: Coordinator, ShowingFocusPicker, ShowingTimer, Dismissing {
    weak var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let color: UIColor?
    private let subject: Subject?
    
    init(navigationController: UINavigationController, color: UIColor?, subject: Subject?) {
        self.navigationController = navigationController
        self.color = color
        self.subject = subject
    }
    
    func start() {
        let viewModel = FocusSelectionViewModel(subject: self.subject)
        let vc = FocusSelectionViewController(viewModel: viewModel, color: self.color)
        vc.coordinator = self
        vc.navigationItem.hidesBackButton = true
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func showFocusPicker(timerCase: TimerCase?) {
        let child = FocusPickerCoordinator(navigationController: self.navigationController, timerCase: timerCase, color: self.color, subject: self.subject)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showTimer(totalTimeInSeconds: Int, subject: Subject?, timerCase: TimerCase) {
        let viewModel = FocusSessionViewModel(totalSeconds: totalTimeInSeconds, subject: subject, timerCase: timerCase)
        let vc = FocusSessionViewController(viewModel: viewModel, color: self.color)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        if let focusSelectionVC = self.navigationController.viewControllers.last as? FocusSelectionViewController {
            nav.transitioningDelegate = focusSelectionVC
        }
        
        self.navigationController.present(nav, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popToRootViewController(animated: true)
    }
}
