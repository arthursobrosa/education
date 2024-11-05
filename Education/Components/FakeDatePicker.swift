//
//  FakeDatePicker.swift
//  Education
//
//  Created by Arthur Sobrosa on 12/09/24.
//

import UIKit

class FakeDatePicker: UIDatePicker {
    override var date: Date {
        didSet {
            dateLabel.text = getDateString(from: date)
        }
    }

    private let dateContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground

        view.isUserInteractionEnabled = false

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .systemText50

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addTarget(self, action: #selector(datePickerDidChange), for: .valueChanged)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func datePickerDidChange() {
        dateLabel.text = getDateString(from: date)
    }

    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        if datePickerMode == .date {
            dateFormatter.setLocalizedDateFormatFromTemplate("MMddyyyy")
        } else {
            let is24HourFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)?.contains("a") == false

            if is24HourFormat {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "hh:mm a"
            }
        }

        return dateFormatter.string(from: date)
    }
}

extension FakeDatePicker: ViewCodeProtocol {
    func setupUI() {
        addSubview(dateContainerView)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateContainerView.widthAnchor.constraint(equalTo: widthAnchor),
            dateContainerView.heightAnchor.constraint(equalTo: heightAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: dateContainerView.trailingAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor),
        ])
    }
}
