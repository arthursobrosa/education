//
//  TimerSettingsView.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import Foundation
import UIKit

class TimerSettingsView: UIView {
    private let viewModel: TimerSettingsViewModel
    
    // MARK: - Properties
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textColor = .label
        label.text = "00:01"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timerPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: .valueChanged)
        return picker
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initializer
    init(frame: CGRect, viewModel: TimerSettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func timePickerChanged(sender: UIDatePicker) {
        self.viewModel.selectedTime = sender.countDownDuration // Update the selectedTime variable
        
        timerLabel.text = self.viewModel.getTimeString(from: sender.date) // Update button title with selected time
    }
}

// MARK: - Setup UI
extension TimerSettingsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerPicker)
        self.addSubview(timerLabel)
        self.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            timerPicker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            timerPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerPicker.widthAnchor.constraint(equalTo: self.widthAnchor),
            timerPicker.heightAnchor.constraint(equalToConstant: 250),
            
            timerLabel.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 100),
            timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])
    }
}
