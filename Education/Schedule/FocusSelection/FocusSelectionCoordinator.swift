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
    
    func showTimer<T: UIViewControllerTransitioningDelegate>(transitioningDelegate: T, timerState: FocusSessionViewModel.TimerState?, totalSeconds: Int, timerSeconds: Int, subject: Subject?, timerCase: TimerCase, isAtWorkTime: Bool) {
        let viewModel = FocusSessionViewModel(totalSeconds: totalSeconds, timerSeconds: timerSeconds, subject: subject, timerCase: timerCase, isAtWorkTime: isAtWorkTime)
        viewModel.timerState.value = timerState
        let vc = FocusSessionViewController(viewModel: viewModel, color: self.color)
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.transitioningDelegate = transitioningDelegate
        
        self.navigationController.present(nav, animated: true)
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
}
