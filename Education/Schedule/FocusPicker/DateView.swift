//
//  DateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class DateView: UIView {
    private let timerCase: TimerCase?

    let timerDatePicker: CustomDatePickerView = {
        let picker = CustomDatePickerView()

        picker.hoursPicker.tag = PickerCase.timerHours
        picker.minutesPicker.tag = PickerCase.timerMinutes

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

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        guard let timerCase else { return }

        switch timerCase {
        case .timer:
            setTimer()
        case .pomodoro:
            setPomodoro()
        default:
            break
        }
    }

    private func setTimer() {
        addSubview(timerDatePicker)

        NSLayoutConstraint.activate([
            timerDatePicker.centerYAnchor.constraint(equalTo: centerYAnchor),
            timerDatePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            timerDatePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func setPomodoro() {
        addSubview(pomodoroDateView)

        NSLayoutConstraint.activate([
            pomodoroDateView.topAnchor.constraint(equalTo: topAnchor),
            pomodoroDateView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pomodoroDateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pomodoroDateView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
