//
//  NoSubjectsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import UIKit

class NoSubjectsView: UIView {
    
    // MARK: - UI Components
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "createText")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "create"))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        stack.addSubview(messageLabel)
        stack.addSubview(button)
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.heightAnchor.constraint(equalToConstant: 200),
            stack.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 4/14),
            button.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            button.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -50)
        ])
    }
    
    // MARK: - Actions
    func setButtonTarget(target: AnyObject, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
