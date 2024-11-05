//
//  NoSchedulesView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/09/24.
//

import UIKit

class NoSchedulesView: UIView {
    // MARK: - Properties

    enum NoSchedulesCase {
        case day
        case week

        var message: String {
            switch self {
            case .day:
                String(localized: "emptyDaySchedule")
            case .week:
                String(localized: "emptyWeekSchedule")
            }
        }
    }

    var period: NoSchedulesCase? {
        didSet {
            guard let period else { return }

            messageLabel.text = "🍃\n\n\(period.message)"

            setupUI()
        }
    }

    // MARK: - UI Components

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension NoSchedulesView: ViewCodeProtocol {
    func setupUI() {
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 245 / 390),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 150),
        ])
    }
}
