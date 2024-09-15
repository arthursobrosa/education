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
    
    private let stack: UIView = {
        let stack = UIView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
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
        let button = ButtonComponent(title: String(localized: "create"))
        button.layer.cornerRadius = 25
        
        button.addTarget(self.delegate, action: #selector(ScheduleDelegate.emptyViewButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension NoSubjectsView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(stack)
        self.addSubview(welcomeLabel)
        self.addSubview(messageLabel)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 115),
            stack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 293/390),
            stack.heightAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 176/293),
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: stack.topAnchor),
            welcomeLabel.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            
            button.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 171/293),
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 55/171),
            button.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: stack.bottomAnchor)
        ])
    }
}
