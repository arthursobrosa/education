//
//  FocusAlertView.swift
//  Education
//
//  Created by Lucas Cunha on 02/09/24.
//

import UIKit

enum FocusAlertCase {
    case restart
    case finish
    
    var title: String {
        switch self {
            case .restart:
                String(localized: "restartAlertTitle")
            case .finish:
                String(localized: "finishEarlyAlertTitle")
        }
    }
    
    var body: String {
        switch self {
            case .restart:
                String(localized: "restartAlertBody")
            case .finish:
                String(localized: "finishEarlyAlertBody")
        }
    }
    
    var action: Selector {
        switch self {
            case .restart:
                #selector(FocusSessionDelegate.didRestart)
            case .finish:
                #selector(FocusSessionDelegate.didFinish)
        }
    }
}

class FocusAlertView: UIView {
    weak var delegate: (any FocusSessionDelegate)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 17)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var yesButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "yes"), cornerRadius: 30)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var cancelButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "cancel"), textColor: .label)
        button.backgroundColor = .clear
        
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        
        button.addTarget(self.delegate, action: #selector(FocusSessionDelegate.cancelButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.setupUI()
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with alertCase: FocusAlertCase) {
        self.titleLabel.text = alertCase.title
        self.bodyLabel.text = alertCase.body
        self.yesButton.addTarget(self.delegate, action: alertCase.action, for: .touchUpInside)
    }
}

extension FocusAlertView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(bodyLabel)
        self.addSubview(yesButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            bodyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 290/360),
            
            cancelButton.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: padding * 4),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
            cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 160/360),
            cancelButton.heightAnchor.constraint(equalTo: yesButton.widthAnchor, multiplier: 55/160),
            
            yesButton.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: padding * 4),
            yesButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 12),
            yesButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 160/360),
            yesButton.heightAnchor.constraint(equalTo: yesButton.widthAnchor, multiplier: 55/160)
        ])
    }
}
