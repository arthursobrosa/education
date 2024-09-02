//
//  NoSubjectsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 30/08/24.
//

import Foundation

import UIKit

class NoSubjectsView: UIView {
    
    // MARK: - UI Components
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Crie uma matéria antes de iniciar seu cronograma"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
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
        stack.addArrangedSubview(messageLabel)
        stack.addArrangedSubview(button)
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.heightAnchor.constraint(equalToConstant: 200),
            stack.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Actions
    func setButtonTarget(target: AnyObject, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
}
