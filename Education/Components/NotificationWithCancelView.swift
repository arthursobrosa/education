//
//  NotificationWithCancelView.swift
//  Education
//
//  Created by Lucas Cunha on 02/09/24.
//

import UIKit

class NotificationWithCancelView: UIView {
    weak var delegate: (any FocusSessionDelegate)?
    private var color: UIColor
    
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
    
    private let yesButton: UIButton = {
        ButtonComponent(title: String(localized: "yes"))
    }()
    
    private lazy var cancelButton: UIButton = {
       let btn = ButtonComponent(title: String(localized: "cancel"), textColor: color)
        
        btn.backgroundColor = UIColor.systemGray5

        return btn
    }()
    
    init(body: String, color: UIColor) {
        self.color = color
        
        super.init(frame: .zero)
        
        self.bodyLabel.text = body

        
        self.setupUI()
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addYesButtonTarget() {
        self.yesButton.addTarget(delegate, action: #selector(FocusSessionDelegate.didFinish), for: .touchUpInside)
    }
    
    func addCancelButtonTarget() {
        self.cancelButton.addTarget(delegate, action: #selector(FocusSessionDelegate.cancelButtonPressed), for: .touchUpInside)
    }
}

extension NotificationWithCancelView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(bodyLabel)
        self.addSubview(yesButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding * 2),
            bodyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 290/360),
            
            cancelButton.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: padding * 4),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 160/360),
            cancelButton.heightAnchor.constraint(equalTo: yesButton.widthAnchor, multiplier: 55/160),
            
            yesButton.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: padding * 4),
            yesButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 12),
            yesButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 160/360),
            yesButton.heightAnchor.constraint(equalTo: yesButton.widthAnchor, multiplier: 55/160),
            
        ])
    }
}
