//
//  NotificationView.swift
//  Education
//
//  Created by Lucas Cunha on 30/08/24.
//


import UIKit

class NotificationComponentView: UIView {
    weak var delegate: (any FocusSessionDelegate)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var okButton: ButtonComponent = {
        let button = ButtonComponent(title: "OK", cornerRadius: 30)
        
        button.addTarget(self.delegate, action: #selector(FocusSessionDelegate.okButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(title: String, body: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.titleLabel.text = title
        self.bodyLabel.text = body
        
        self.backgroundColor = .systemBackground
        
        self.setupUI()
        
        self.backgroundColor = color
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationComponentView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(bodyLabel)
        self.addSubview(okButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding * 2),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 290/360),
            
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: padding * 2),
            bodyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 290/360),
            
            okButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            okButton.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: padding * 4),
            okButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 312/360),
            okButton.heightAnchor.constraint(equalTo: okButton.widthAnchor, multiplier: 55/312),
        ])
    }
}
