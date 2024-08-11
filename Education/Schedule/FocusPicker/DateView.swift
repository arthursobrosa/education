//
//  DateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class DateView: UIView {
    weak var delegate: FocusPickerDelegate? {
        didSet {
            self.setupUI()
        }
    }
    
    private let timerCase: TimerCase?
    
    let timerDatePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()
    
    lazy var pomodoroWorkDatePicker: CustomDateButton = {
        let font: UIFont = .systemFont(ofSize: 30, weight: .semibold)
        let picker = CustomDateButton(font: font, hours: 0, minutes: 25)
        picker.datePicker.tag = 0
        picker.datePicker.addTarget(self, action: #selector(pomodoroDatePickerChanged(_:)), for: .valueChanged)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    lazy var pomodoroRestDatePicker: CustomDateButton = {
        let font: UIFont = .systemFont(ofSize: 24, weight: .semibold)
        let picker = CustomDateButton(font: font, hours: 0, minutes: 5)
        picker.datePicker.tag = 1
        picker.datePicker.addTarget(self, action: #selector(pomodoroDatePickerChanged(_:)), for: .valueChanged)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    init(timerCase: TimerCase?) {
        self.timerCase = timerCase
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pomodoroDatePickerChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: sender.date)
        
        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute else { return }
        
        let timeInSeconds = hour * 3600 + minute * 60
        
        self.delegate?.pomodoroDateChanged(tag: sender.tag, time: timeInSeconds)
    }
    
    private func setupUI() {
        guard let timerCase else { return }
        
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
        
        NSLayoutConstraint.activate([
            timerDatePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timerDatePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timerDatePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func setPomodoro() {
        self.addSubview(pomodoroWorkDatePicker)
        self.addSubview(pomodoroRestDatePicker)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            pomodoroWorkDatePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (200/310)),
            pomodoroWorkDatePicker.heightAnchor.constraint(equalTo: pomodoroWorkDatePicker.widthAnchor, multiplier: (57/200)),
            pomodoroWorkDatePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            pomodoroWorkDatePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            pomodoroRestDatePicker.topAnchor.constraint(equalTo: pomodoroWorkDatePicker.bottomAnchor, constant: padding),
            pomodoroRestDatePicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (174/310)),
            pomodoroRestDatePicker.heightAnchor.constraint(equalTo: pomodoroRestDatePicker.widthAnchor, multiplier: (50/200)),
            pomodoroRestDatePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
