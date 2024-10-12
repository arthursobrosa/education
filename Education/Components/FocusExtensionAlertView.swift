//
//  FocusExtensionAlertView.swift
//  Education
//
//  Created by Arthur Sobrosa on 11/10/24.
//

import UIKit

enum FocusExtensionAlertCase {
    case timer
    case pomodoro(isAtWorkTime: Bool)
    
    var title: String {
        switch self {
            case .timer:
                String(format: NSLocalizedString("extendSomething", comment: ""), String(localized: "activity"))
            case .pomodoro(let isAtWorkTime):
                String(format: NSLocalizedString("extendSomething", comment: ""), isAtWorkTime ? String(localized: "focusTime") : String(localized: "pauseTime"))
        }
    }
    
    var primaryButtonAction: Selector {
        switch self {
            case .timer:
                #selector(FocusSessionDelegate.didExtendTimer)
            case .pomodoro:
                #selector(FocusSessionDelegate.didExtendPomodoro)
        }
    }
}

class FocusExtensionAlertView: UIView {
    // MARK: - Delegate
    weak var delegate: (any FocusSessionDelegate)?
    
    // MARK: - UI Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var secondaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "cancel"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(FocusSessionDelegate.didCancelExtend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var primaryButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "continue"), cornerRadius: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with extendTimerCase: FocusExtensionAlertCase, atSuperview superview: UIView) {
        titleLabel.text = extendTimerCase.title
        setPrimaryButton(with: extendTimerCase)
        setupUI()
        layoutToSuperview(superview)
    }
    
    private func setPrimaryButton(with extendTimerCase: FocusExtensionAlertCase) {
        primaryButton.addTarget(delegate, action: extendTimerCase.primaryButtonAction, for: .touchUpInside)
    }
}

// MARK: - UI Setup
extension FocusExtensionAlertView: ViewCodeProtocol {
    func setupUI() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
        ])
    }
    
    private func layoutToSuperview(_ superview: UIView) {
        removeFromSuperview()
        
        superview.addSubview(self)
        addSubview(secondaryButton)
        addSubview(primaryButton)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 366 / 390),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 318 / 366),
            
            secondaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 366),
            secondaryButton.heightAnchor.constraint(equalTo: secondaryButton.widthAnchor, multiplier: 55 / 160),
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            
            primaryButton.widthAnchor.constraint(equalTo: secondaryButton.widthAnchor),
            primaryButton.heightAnchor.constraint(equalTo: secondaryButton.heightAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 12),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor),
        ])
    }
}
