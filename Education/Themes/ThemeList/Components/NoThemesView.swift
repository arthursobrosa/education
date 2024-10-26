//
//  NoThemesView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/09/24.
//

import UIKit

class NoThemesView: UIView {
    // MARK: - Properties

    weak var themeDelegate: (any ThemeListDelegate)?
    weak var testDelegate: (any ThemePageDelegate)?

    enum NoThemesCase {
        case theme
        case test

        var icon: String {
            switch self {
            case .theme:
                "🫧"
            case .test:
                "🪁"
            }
        }

        var message: String {
            switch self {
            case .theme:
                String(localized: "emptyTheme")
            case .test:
                String(localized: "emptyTest")
            }
        }

        var buttonTitle: String {
            switch self {
            case .theme:
                String(localized: "newTheme")
            case .test:
                String(localized: "newTest")
            }
        }

        var action: Selector {
            switch self {
            case .theme:
                #selector(ThemeListDelegate.addThemeButtonTapped)
            case .test:
                #selector(ThemePageDelegate.addTestButtonTapped)
            }
        }
    }

    var noThemesCase: NoThemesCase? {
        didSet {
            guard let noThemesCase else { return }

            messageLabel.text = "\(noThemesCase.icon)\n\n\(noThemesCase.message)"
            setButton()

            setupUI()
        }
    }

    // MARK: - UI Components

    private let stack: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

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

    private var button: ButtonComponent?

    // MARK: - Methods

    private func setButton() {
        guard let noThemesCase else { return }

        button = ButtonComponent(title: noThemesCase.buttonTitle, textColor: .label, cornerRadius: 27)
        button?.backgroundColor = .clear
        button?.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
        button?.layer.borderWidth = 1

        if noThemesCase == .theme {
            button?.addTarget(themeDelegate, action: noThemesCase.action, for: .touchUpInside)
        } else {
            button?.addTarget(testDelegate, action: noThemesCase.action, for: .touchUpInside)
        }

        button?.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UI Setup

extension NoThemesView: ViewCodeProtocol {
    func setupUI() {
        guard let button else { return }

        addSubview(stack)
        addSubview(messageLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 245 / 390),
            stack.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 170 / 245),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),

            messageLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),

            button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 171 / 390),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 55 / 171),
            button.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
        ])
    }
}
