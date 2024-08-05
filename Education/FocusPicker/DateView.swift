//
//  DateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class DateView: UIView {
    var timerCase: TimerCase? {
        didSet {
            guard let timerCase = timerCase else { return }
            
            self.setupUI(timerCase: timerCase)
        }
    }
    
    let timerDatePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()
    
    let pomodoroWorkDatePicker: CustomDateButton = {
        let picker = CustomDateButton()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let pomodoroRestDatePicker: CustomDateButton = {
        let picker = CustomDateButton()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private func setupUI(timerCase: TimerCase) {
        switch timerCase {
            case .timer:
                self.setTimer()
            case .pomodoro:
                self.setPomodoro()
            default:
                break
        }
    }
    
    private func setTimer() {
        self.addSubview(timerDatePicker)
        
        let padding = 36.0
        
        NSLayoutConstraint.activate([
            timerDatePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerDatePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            timerDatePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
        ])
    }
    
    private func setPomodoro() {
        self.addSubview(pomodoroWorkDatePicker)
        self.addSubview(pomodoroRestDatePicker)
        
        let padding = 50.0
        
        NSLayoutConstraint.activate([
            pomodoroWorkDatePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (200/323)),
            pomodoroWorkDatePicker.heightAnchor.constraint(equalTo: pomodoroWorkDatePicker.widthAnchor, multiplier: (57/200)),
            pomodoroWorkDatePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            pomodoroWorkDatePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pomodoroRestDatePicker.topAnchor.constraint(equalTo: pomodoroWorkDatePicker.bottomAnchor, constant: padding),
            pomodoroRestDatePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (174/323)),
            pomodoroRestDatePicker.heightAnchor.constraint(equalTo: pomodoroRestDatePicker.widthAnchor, multiplier: (57/200)),
            pomodoroRestDatePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
