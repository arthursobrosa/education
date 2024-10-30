//
//  DeleterAlertView.swift
//  Education
//
//  Created by Arthur Sobrosa on 17/10/24.
//

import UIKit

class DeleteAlertView: UIView {
    // MARK: - Delegate

    weak var delegate: (any ThemeListDelegate)?

    // MARK: UI Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "deleteThemeTitle")
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "deleteThemeBody")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var secondaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "cancel"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(ThemeListDelegate.dismissDeleteAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var primaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), cornerRadius: 28)
        button.addTarget(delegate, action: #selector(ThemeListDelegate.removeTheme), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        layer.cornerRadius = 12

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(atSuperview superview: UIView) {
        setupUI()
        layoutToSuperview(superview)
    }
}

// MARK: - UI Setup

extension DeleteAlertView: ViewCodeProtocol {
    func setupUI() {
        for subview in subviews {
            subview.removeFromSuperview()
        }

        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(secondaryButton)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),

            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 290 / 360),

            secondaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 366),
            secondaryButton.heightAnchor.constraint(equalTo: secondaryButton.widthAnchor, multiplier: 55 / 160),
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),

            primaryButton.widthAnchor.constraint(equalTo: secondaryButton.widthAnchor),
            primaryButton.heightAnchor.constraint(equalTo: secondaryButton.heightAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 12),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor),
        ])
    }

    private func layoutToSuperview(_ superview: UIView) {
        removeFromSuperview()

        superview.addSubview(self)
        addSubview(secondaryButton)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 366 / 390),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 318 / 366),

            secondaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 366),
            secondaryButton.heightAnchor.constraint(equalTo: secondaryButton.widthAnchor, multiplier: 55 / 160),
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),

            primaryButton.widthAnchor.constraint(equalTo: secondaryButton.widthAnchor),
            primaryButton.heightAnchor.constraint(equalTo: secondaryButton.heightAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 12),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor),
        ])
    }
}
