//
//  DayView.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

struct DayOfWeek {
    let day: String
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

            dateLabel.text = dayOfWeek.day.prefix(1).uppercased()

            handleDayColors()
        }
    }

    // MARK: - UI Components

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTapGesture()
        setupUI()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.handleDayColors()
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.width / 2
    }

    // MARK: - Methods

    @objc 
    private func dayViewTapped() {
        delegate?.dayTapped(self)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayViewTapped))
        addGestureRecognizer(tapGesture)
    }
}

// MARK: UI Setup

extension DayView: ViewCodeProtocol {
    func setupUI() {
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func handleDayColors() {
        guard let dayOfWeek else { return }

        let isSelected = dayOfWeek.isSelected
        let isToday = dayOfWeek.isToday

        let dateLabelFontName = isSelected ? Fonts.darkModeOnSemiBold : Fonts.darkModeOnMedium

        dateLabel.font = UIFont(name: dateLabelFontName, size: 15)
        dateLabel.textColor = isSelected ? .systemBackground : (isToday ? UIColor(named: "system-text") : UIColor(named: "system-text-50"))

        if let systemTextColor = UIColor(named: "system-text")?.cgColor,
           let systemText50Color = UIColor(named: "system-text-50")?.cgColor {
            layer.borderColor = isToday ? systemTextColor : systemText50Color
        }

        layer.borderWidth = isSelected ? 0 : 1
        backgroundColor = isSelected ? UIColor(named: "system-text") : .clear
    }
}
