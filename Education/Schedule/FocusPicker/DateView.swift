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
    
    let pomodoroDateView: PomodoroDateView = {
        let view = PomodoroDateView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        self.addSubview(pomodoroDateView)
        
        NSLayoutConstraint.activate([
            pomodoroDateView.topAnchor.constraint(equalTo: self.topAnchor),
            pomodoroDateView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            pomodoroDateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pomodoroDateView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
