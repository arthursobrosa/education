//
//  FocusSessionViewController.swift
//  Education
//
//  Created by Lucas Cunha on 01/07/24.
//

import UIKit

class FocusSessionViewController: UIViewController {
    // MARK: - Properties
    weak var coordinator: Dismissing?
    private let viewModel: FocusSessionViewModel
    
    private lazy var timerView: FocusSessionView =  {
        let timerView = FocusSessionView(frame: .zero, viewModel: self.viewModel)
        return timerView
    }()
    
    // MARK: - Initializer
    init(viewModel: FocusSessionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        
        self.view = self.timerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.onChangeSecond = { [weak self] time in
            guard let self = self else { return }
            
            self.timerView.timerLabel.text = String(format: "%02i:%02i:%02i", time / 3600, (time - (time / 3600) * 3600)/60, time % 60)
            
            if time == 0 {
                self.showEndTimeAlert()
            }
        }
    }
    
    // MARK: - Methods
    private func showEndTimeAlert() {
        let alertController = UIAlertController(title: "Time's up!", message: "Your timer is finished", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.timer?.cancel()
            self.coordinator?.dismiss()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
