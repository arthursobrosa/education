//
//  DayView.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

struct DayOfWeek {
    let day: String
    let date: String
    let isSelected: Bool
    let isToday: Bool
}

class DayView: UIView {
    // MARK: - Delegate

    weak var delegate: ScheduleDelegate?

    // MARK: - Properties

    var dayOfWeek: DayOfWeek? {
        didSet {
            guard let dayOfWeek else { return }

            dayLabel.text = dayOfWeek.day.lowercased()
            dateLabel.text = dayOfWeek.date

            handleDayColors()
        }
    }

    // MARK: - UI Components

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 13)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayViewTapped))
        addGestureRecognizer(tapGesture)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        circleView.layer.cornerRadius = circleView.bounds.width / 2
    }

    // MARK: - Methods

    @objc 
    private func dayViewTapped() {
        delegate?.dayTapped(self)
    }
}

// MARK: UI Setup

extension DayView: ViewCodeProtocol {
    func setupUI() {
        addSubview(dayLabel)
        circleView.addSubview(dateLabel)
        addSubview(circleView)

        let padding = 4.0

        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            circleView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            circleView.widthAnchor.constraint(equalTo: widthAnchor),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),

            dateLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
        ])

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.handleDayColors()
        }
    }

    func handleDayColors() {
        guard let dayOfWeek else { return }

        let isSelected = dayOfWeek.isSelected
        let isToday = dayOfWeek.isToday

        let dayLabelFontName = (isSelected || isToday) ? Fonts.darkModeOnRegular : Fonts.darkModeOnMedium

        dayLabel.font = UIFont(name: dayLabelFontName, size: 13)
        dayLabel.textColor = (isSelected || isToday) ? UIColor(named: "system-text") : UIColor(named: "system-text-50")

        let dateLabelFontName = isSelected ? Fonts.darkModeOnSemiBold : Fonts.darkModeOnMedium

        dateLabel.font = UIFont(name: dateLabelFontName, size: 15)
        dateLabel.textColor = isSelected ? .systemBackground : (isToday ? UIColor(named: "system-text") : UIColor(named: "system-text-50"))

        if let systemTextColor = UIColor(named: "system-text")?.cgColor,
           let systemText50Color = UIColor(named: "system-text-50")?.cgColor {
            circleView.layer.borderColor = isToday ? systemTextColor : systemText50Color
        }

        circleView.layer.borderWidth = isSelected ? 0 : 1
        circleView.backgroundColor = isSelected ? UIColor(named: "system-text") : .clear
    }
}
