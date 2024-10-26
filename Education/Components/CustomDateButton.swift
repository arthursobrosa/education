//
//  CustomDateButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class CustomDateButton: UIView {
    var color: UIColor? {
        didSet {
            guard let color else { return }

            dateLabelBack.backgroundColor = color
        }
    }

    private var hours: Int
    private var minutes: Int

    private let dateLabelBack: UIView = {
        let view = UIView()
        view.layer.zPosition = 1

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()

        var hoursText = "\(self.hours)"
        var minutesText = "\(self.minutes)"

        if self.hours < 10 {
            hoursText = "0" + "\(self.hours)"
        }

        if self.minutes < 10 {
            minutesText = "0" + "\(self.minutes)"
        }

        label.text = "\(hoursText)h  \(minutesText)min"
        label.textAlignment = .center
        label.textColor = .white

        label.isUserInteractionEnabled = false

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.layer.zPosition = 0

        let calendar = Calendar.current
        let dateComponents = DateComponents(
            hour: self.hours,
            minute: self.minutes
        )

        if let date = calendar.date(from: dateComponents) {
            picker.date = date
        }

        picker.addTarget(self, action: #selector(didTapPicker(_:)), for: .valueChanged)

        picker.translatesAutoresizingMaskIntoConstraints = false

        return picker
    }()

    init(font: UIFont, hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes

        super.init(frame: .zero)

        dateLabel.font = font

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        dateLabelBack.layer.cornerRadius = dateLabelBack.bounds.height / 4

        let dateWidth = datePicker.bounds.width
        let backWidth = dateLabelBack.bounds.width
        let scaleX = backWidth / dateWidth

        let dateHeight = datePicker.bounds.height
        let backHeight = dateLabelBack.bounds.height
        let scaleY = backHeight / dateHeight

        datePicker.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    }

    @objc private func didTapPicker(_ sender: UIDatePicker) {
        let calendar = Calendar.current

        let dateComponents = calendar.dateComponents([.hour, .minute], from: sender.date)

        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute else { return }

        if hour == 0 && minute == 0 {
            let newDateComponents = DateComponents(
                hour: 0,
                minute: 1
            )

            guard let newDate = calendar.date(from: newDateComponents) else { return }

            sender.date = newDate

            didTapPicker(sender)
            return
        }

        var hoursText = "\(hour)"
        var minutesText = "\(minute)"

        if hour < 10 {
            hoursText = "0" + "\(hour)"
        }

        if minute < 10 {
            minutesText = "0" + "\(minute)"
        }

        dateLabel.text = "\(hoursText)h \(minutesText)min"
    }
}

extension CustomDateButton: ViewCodeProtocol {
    func setupUI() {
        addSubview(dateLabelBack)
        dateLabelBack.addSubview(dateLabel)
        addSubview(datePicker)

        let padding = 15.0

        NSLayoutConstraint.activate([
            dateLabelBack.widthAnchor.constraint(equalTo: widthAnchor),
            dateLabelBack.heightAnchor.constraint(equalTo: heightAnchor),
            dateLabelBack.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabelBack.centerYAnchor.constraint(equalTo: centerYAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: dateLabelBack.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: dateLabelBack.trailingAnchor, constant: -padding),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            datePicker.centerXAnchor.constraint(equalTo: centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
