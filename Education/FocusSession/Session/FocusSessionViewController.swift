//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class FocusSessionViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (Dismissing & HidingBackButton)?
    private let viewModel: FocusSessionViewModel
    
    // MARK: - Properties
    private lazy var focusSessionView = FocusSessionView(viewModel: self.viewModel)
    
    init(viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.focusSessionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coordinator?.hideBackButton(true)
        
        self.focusSessionView.onTimerFinished = { [weak self] in
            guard let self = self else { return }
            
            self.showEndTimeAlert()
        }
        
        self.focusSessionView.onChangeTimerState = { [weak self] isPaused in
            guard let self = self else { return }
            
            self.coordinator?.hideBackButton(!isPaused)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.focusSessionView.setupLayers()
            self.viewModel.startFocusSession()
        }
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
