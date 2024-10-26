//
//  CustomDatePickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class CustomDatePickerView: UIView {
    let hoursPicker: UIPickerView = {
        let picker = UIPickerView()

        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()

    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 30)
        label.text = "h"
        label.textColor = .label
        label.textAlignment = .center
        label.alpha = 0.8

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let minutesPicker: UIPickerView = {
        let picker = UIPickerView()

        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()

    private let minutesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 30)
        label.text = "min"
        label.textColor = .label
        label.textAlignment = .center
        label.alpha = 0.8

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in hoursPicker.subviews {
            subview.backgroundColor = .clear
        }

        for subview in minutesPicker.subviews {
            subview.backgroundColor = .clear
        }
    }
}

private extension CustomDatePickerView {
    func setupUI() {
        addSubview(hoursPicker)
        addSubview(hoursLabel)
        addSubview(minutesPicker)
        addSubview(minutesLabel)

        let padding = 8.0

        NSLayoutConstraint.activate([
            hoursPicker.topAnchor.constraint(equalTo: topAnchor),
            hoursPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            hoursPicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            hoursPicker.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 105 / 310),

            hoursLabel.centerYAnchor.constraint(equalTo: hoursPicker.centerYAnchor),
            hoursLabel.leadingAnchor.constraint(equalTo: hoursPicker.trailingAnchor, constant: -padding),

            minutesPicker.topAnchor.constraint(equalTo: topAnchor),
            minutesPicker.bottomAnchor.constraint(equalTo: bottomAnchor),
            minutesPicker.leadingAnchor.constraint(equalTo: hoursLabel.trailingAnchor),
            minutesPicker.widthAnchor.constraint(equalTo: hoursPicker.widthAnchor),

            minutesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            minutesLabel.leadingAnchor.constraint(equalTo: minutesPicker.trailingAnchor, constant: -padding),
        ])
    }
}
