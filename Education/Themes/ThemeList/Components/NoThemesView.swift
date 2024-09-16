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
            
            self.messageLabel.text = "🫧\n\n\(noThemesCase.message)"
            self.setButton()
            
            self.setupUI()
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
        
        self.button = ButtonComponent(title: noThemesCase.buttonTitle, textColor: .label, cornerRadius: 27)
        self.button?.backgroundColor = .clear
        self.button?.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
        self.button?.layer.borderWidth = 1
        
        self.button?.addTarget(noThemesCase == .theme ? self.themeDelegate : self.testDelegate, action: noThemesCase.action, for: .touchUpInside)
        
        self.button?.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UI Setup
extension NoThemesView: ViewCodeProtocol {
    func setupUI() {
        guard let button else { return }
        
        self.addSubview(stack)
        self.addSubview(messageLabel)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 245/390),
            stack.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 170/245),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            button.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 171/390),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 55/171),
            button.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
    }
}
