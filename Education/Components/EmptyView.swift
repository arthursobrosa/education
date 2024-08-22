//
//  EmptyView.swift
//  Education
//
//  Created by Arthur Sobrosa on 18/07/24.
//

import UIKit

class EmptyView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        
        self.messageLabel.text = message
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(messageLabel)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding * 2),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(padding * 2))
        ])
    }
}
