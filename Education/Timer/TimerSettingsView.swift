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
    private lazy var timerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pick time", for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var timerPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = true // Initially hidden
        picker.addTarget(self, action: #selector(timePickerChanged(sender:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.isHidden = true // Initially hidden
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
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
    @objc func showDatePicker() {
        let shouldShow = timerPicker.isHidden
        timerPicker.isHidden = !shouldShow // Toggle visibility of the date picker
        saveButton.isHidden = !shouldShow // Toggle visibility of the save button
    }
    
    @objc func timePickerChanged(sender: UIDatePicker) {
        self.viewModel.selectedTime = sender.countDownDuration // Update the selectedTime variable
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: sender.date)
        timerButton.setTitle(timeString, for: .normal) // Update button title with selected time
        self.viewModel.printSelectedTime() // Print the selected time
    }
    
    @objc func saveButtonClicked() {
        timerPicker.isHidden = true // Hide the date picker
        saveButton.isHidden = true // Hide the save button
    }
}

// MARK: - Setup UI
extension TimerSettingsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(timerButton)
        self.addSubview(timerPicker)
        self.addSubview(saveButton)
        self.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            timerButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            timerPicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerPicker.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: 20),
            timerPicker.widthAnchor.constraint(equalTo: self.widthAnchor),
            timerPicker.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: timerPicker.bottomAnchor, constant: 20),
            saveButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])
    }
}
