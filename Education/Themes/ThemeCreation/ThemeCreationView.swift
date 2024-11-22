//
//  ThemeCreationView.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeCreationView: UIView {
    weak var delegate: ThemeCreationDelegate? {
        didSet {
            delegate?.setTextFieldDelegate(textField)
        }
    }

    private let themeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .systemText

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    lazy var textField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.textInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        
        let placeholderColor = UIColor.systemText40
        let placeholderFont = UIFont(name: Fonts.darkModeOnItalic, size: 15)
        let placeholderText = String(localized: "themeAlertPlaceholder")
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont ?? UIFont.italicSystemFont(ofSize: 15),
            .foregroundColor: placeholderColor as Any,
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        textField.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)

        textField.layer.borderColor = UIColor(named: "button-normal")?.cgColor
        textField.layer.borderWidth = 1

        textField.layer.cornerRadius = 18

        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    lazy var cancelButton: ButtonComponent = {
        let button = ButtonComponent(
            insets: NSDirectionalEdgeInsets(top: 16, leading: 45, bottom: 16, trailing: 45),
            title: String(localized: "cancel"),
            textColor: .systemText80,
            fontStyle: Fonts.darkModeOnMedium,
            fontSize: 17,
            cornerRadius: 28
        )
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        button.tintColor = .systemModalBg

        button.layer.borderColor = UIColor(named: "button-normal")?.cgColor
        button.layer.borderWidth = 1

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    lazy var continueButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), textColor: .systemModalBg, cornerRadius: 28)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        button.backgroundColor = .buttonSelected
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemModalBg

        layer.cornerRadius = 12

        setupUI()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.updateViewColor(self.traitCollection)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc 
    private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }

        delegate?.textFieldDidChange(newText: text)
    }

    @objc 
    private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }

    @objc 
    private func didTapContinueButton() {
        delegate?.didTapContinueButton()
    }

    func setTitleLabel(theme: Theme?) {
        var isEditing = Bool()

        if let theme {
            isEditing = true
            textField.text = theme.unwrappedName
        } else {
            isEditing = false
        }

        themeTitleLabel.text = isEditing ? String(localized: "editTheme") : String(localized: "newTheme")
    }

    private func updateViewColor(_: UITraitCollection) {
        cancelButton.layer.borderColor = UIColor(named: "button-normal")?.cgColor
        textField.layer.borderColor = UIColor(named: "button-normal")?.cgColor
    }
}

extension ThemeCreationView: ViewCodeProtocol {
    func setupUI() {
        addSubview(themeTitleLabel)
        addSubview(textField)
        addSubview(cancelButton)
        addSubview(continueButton)

        NSLayoutConstraint.activate([
            themeTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            themeTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            textField.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 44),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            textField.heightAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 50 / 334),

            cancelButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 163 / 366),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 55 / 163),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            continueButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            continueButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
        ])
    }
}
