//
//  NoSubjectsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import UIKit

class NoSubjectsView: UIView {
    // MARK: - UI Components

    weak var delegate: (any ScheduleDelegate)?

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.text = String(localized: "welcomeText")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.text = String(localized: "createText")
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var button: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "create"), cornerRadius: 25)

        button.addTarget(delegate, action: #selector(ScheduleDelegate.emptyViewButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
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

extension NoSubjectsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(welcomeLabel)
        addSubview(messageLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 115),
            welcomeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 55 / 171),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
        ])
    }
}
