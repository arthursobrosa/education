//
//  NewThemeView.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class NewThemeView: UIView {
    weak var delegate: NewThemeDelegate? {
        didSet {
            self.delegate?.setTextFieldDelegate(self.textField)
        }
    }
    
    private let themeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "newTheme")
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var textField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.textInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
        textField.placeholder = String(localized: "themeAlertPlaceholder")
        textField.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)
        
        textField.layer.borderColor = UIColor.secondaryLabel.cgColor
        textField.layer.borderWidth = 1
        
        textField.layer.cornerRadius = 18
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var cancelButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "cancel"), textColor: .label)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        button.backgroundColor = .clear
        
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        
        return button
    }()
    
    private lazy var continueButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), textColor: .systemBackground)
        button.addTarget(self, action: #selector(didTapContinueButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        self.layer.cornerRadius = 12
        
        self.setupUI()
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
}

extension NewThemeView: ViewCodeProtocol {
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
