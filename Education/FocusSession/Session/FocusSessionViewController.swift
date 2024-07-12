//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class FocusSessionViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: Dismissing?
    private let viewModel: FocusSessionViewModel
    
    // MARK: - Properties
    private lazy var focusSessionView = FocusSessionView(viewModel: self.viewModel)
    
    // MARK: - Initializer
    init(viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.focusSessionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        self.coordinator?.hideBackButton(true)
//        
        self.focusSessionView.onTimerFinished = { [weak self] in
            guard let self = self else { return }
            
            self.showEndTimeAlert()
        }
        
        self.focusSessionView.onChangeTimerState = { [weak self] isPaused in
            guard let self = self else { return }
            
//            self.coordinator?.hideBackButton(!isPaused)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            if self.viewModel.timerState.value == nil {
                self.viewModel.startFocusSession()
                self.focusSessionView.setupLayers()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.timerState.value = .reseting
    }
    
    // MARK: - Auxiliar Methods
    private func showEndTimeAlert() {
        let alertController = UIAlertController(title: "Time's up!", message: "Your timer is finished", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.coordinator?.dismiss()
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}
