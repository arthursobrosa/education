//
//  NoThemesView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/09/24.
//

import UIKit

class NoThemesView: UIView {
    // MARK: - Delegates

    weak var themeListDelegate: (any ThemeListDelegate)? {
        didSet {
            setButtonTarget(themeListDelegate, action: #selector(ThemeListDelegate.addThemeButtonTapped))
        }
    }
    
    weak var themePageDelegate: (any ThemePageDelegate)? {
        didSet {
            setButtonTarget(themePageDelegate, action: #selector(ThemePageDelegate.addTestButtonTapped))
        }
    }

    // MARK: - UI Properties
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "emptyTheme")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .systemText50
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: ButtonComponent = {
        let button = ButtonComponent(
            title: String(localized: "add"),
            textColor: .systemText80,
            cornerRadius: 27
        )
        
        button.backgroundColor = .clear
        
        button.layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            button.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setButtonTarget(_ target: Any?, action: Selector) {
        addButton.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - UI Setup

extension NoThemesView: ViewCodeProtocol {
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(addButton)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 245 / 390),
            contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 143 / 245),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            addButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 40),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 37),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor, multiplier: 55 / 171),
        ])
    }
}
