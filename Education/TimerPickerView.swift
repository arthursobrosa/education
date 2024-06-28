//
//  TimerPickerViewModel.swift
//  Education
//
//  Created by Lucas Cunha on 28/06/24.
//

import Foundation
import UIKit

class TimerPickerView: UIView {
    
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
    
    private lazy var timePicker: UIDatePicker = {
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
    
    private var selectedTime: TimeInterval = 0 // Variable to hold the selected time
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(timerButton)
        self.addSubview(timePicker)
        self.addSubview(saveButton)
        
        setConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            timerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            timePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timePicker.topAnchor.constraint(equalTo: timerButton.bottomAnchor, constant: 10),
            timePicker.widthAnchor.constraint(equalTo: self.widthAnchor),
            timePicker.heightAnchor.constraint(equalToConstant: 250),
            
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10),
            saveButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showDatePicker() {
        let shouldShow = timePicker.isHidden
        timePicker.isHidden = !shouldShow // Toggle visibility of the date picker
        saveButton.isHidden = !shouldShow // Toggle visibility of the save button
    }
    
    @objc func timePickerChanged(sender: UIDatePicker) {
        selectedTime = sender.countDownDuration // Update the selectedTime variable
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: sender.date)
        timerButton.setTitle(timeString, for: .normal) // Update button title with selected time
        printSelectedTime() // Print the selected time
    }
    
    @objc func saveButtonClicked() {
        timePicker.isHidden = true // Hide the date picker
        saveButton.isHidden = true // Hide the save button
    }
    
    func getSelectedTime() -> TimeInterval {
        return selectedTime
    }
    
    func printSelectedTime() {
        let hours = Int(selectedTime) / 3600
        let minutes = (Int(selectedTime) % 3600) / 60
        print("Selected time is \(hours) hours and \(minutes) minutes.")
    }
}
