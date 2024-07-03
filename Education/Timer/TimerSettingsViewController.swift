//
//  TimerSettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit

class TimerSettingsViewController: UIViewController {
    weak var coordinator: ShowingTimer?
    private let viewModel: TimerSettingsViewModel
    private lazy var timerSettingsView: TimerSettingsView = {
        let timerSettingsView = TimerSettingsView(frame: .zero, viewModel: self.viewModel)
        timerSettingsView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        return timerSettingsView
    }()
    
    init(viewModel: TimerSettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.timerSettingsView
    }
    
    @objc private func startButtonClicked() {
        self.coordinator?.showTimer(Int(self.viewModel.selectedTime/60))
    }
}

