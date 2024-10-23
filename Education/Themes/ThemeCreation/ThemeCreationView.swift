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
            self.delegate?.setTextFieldDelegate(self.textField)
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
        textField.attributedPlaceholder = NSAttributedString(string: String(localized: "themeAlertPlaceholder"), attributes: [.font : UIFont(name: Fonts.darkModeOnItalic, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .regular), .foregroundColor : UIColor(named: "system-text-40") ?? UIColor.red])
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
        
        self.backgroundColor = .systemModalBg
        
        self.layer.cornerRadius = 12
        
        self.setupUI()
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.updateViewColor(self.traitCollection)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        self.delegate?.textFieldDidChange(newText: text)
    }
    
    @objc private func didTapCancelButton() {
        self.delegate?.didTapCancelButton()
    }
    
    @objc private func didTapContinueButton() {
        self.delegate?.didTapContinueButton()
    }
    
    func setTitleLabel(theme: Theme?) {
        var isEditing = Bool()
        
        if let theme {
            isEditing = true
            self.textField.text = theme.unwrappedName
        } else {
            isEditing = false
        }
        
        self.themeTitleLabel.text = isEditing ? String(localized: "editTheme") : String(localized: "newTheme")
    }
    
    private func updateViewColor(_ traitCollection: UITraitCollection) {
        cancelButton.layer.borderColor = UIColor(named: "button-normal")?.cgColor
        textField.layer.borderColor = UIColor(named: "button-normal")?.cgColor
    }
    
}

extension ThemeCreationView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(themeTitleLabel)
        self.addSubview(textField)
        self.addSubview(cancelButton)
        self.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            themeTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            themeTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: themeTitleLabel.bottomAnchor, constant: 44),
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 334/366),
            textField.heightAnchor.constraint(equalTo: textField.widthAnchor, multiplier: 50/334),
            
            cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 163/366),
            cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor, multiplier: 55/163),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            
            continueButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            continueButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            continueButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)
        ])
    }
}
