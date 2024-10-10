//
//  FocusAlertView.swift
//  Education
//
//  Created by Lucas Cunha on 02/09/24.
//

import UIKit

enum FocusAlertCase {
    case restart
    case finishTimer
    case finishActivity(subject: Subject?)
    
    enum AlertPosition {
        case mid
        case bottom
    }
    
    var title: String {
        switch self {
            case .restart:
                String(localized: "restartAlertTitle")
            case .finishTimer:
                String(localized: "finishEarlyAlertTitle")
            case .finishActivity:
                String(localized: "timeIsUp")
        }
    }
    
    var body: String {
        switch self {
            case .restart:
                String(localized: "restartAlertBody")
            case .finishTimer:
                String(localized: "finishEarlyAlertBody")
            case .finishActivity(let subject):
                getBody(with: subject)
        }
    }
    
    var primaryButtonTitle: String {
        switch self {
            case .restart, .finishTimer:
                String(localized: "yes")
            case .finishActivity:
                String(localized: "focusFinish")
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
            case .restart, .finishTimer:
                String(localized: "cancel")
            case .finishActivity:
                String(localized: "extendTime")
        }
    }
    
    var primaryButtonAction: Selector {
        switch self {
            case .restart:
                #selector(FocusSessionDelegate.didRestart)
            case .finishTimer, .finishActivity:
                #selector(FocusSessionDelegate.didFinish)
        }
    }
    
    var secondaryButtonAction: Selector {
        switch self {
            case .restart, .finishTimer:
                #selector(FocusSessionDelegate.cancelButtonPressed)
            case .finishActivity:
                #selector(FocusSessionDelegate.cancelButtonPressed)
        }
    }
    
    var position: AlertPosition {
        switch self {
            case .restart, .finishTimer:
                .bottom
            case .finishActivity:
                .mid
        }
    }
    
    private func getBody(with subject: Subject?) -> String {
        guard case .finishActivity = self else { return String() }
        
        if let subject {
            return String(format: NSLocalizedString("activityEndCongratulations", comment: ""), subject.unwrappedName)
        } else {
            return String(localized: "noActivityEndCongratulations")
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
    
    private var primaryButton: ButtonComponent?
    private var secondaryButton: ButtonComponent?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        layer.cornerRadius = 12
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with alertCase: FocusAlertCase, atSuperview superview: UIView) {
        titleLabel.text = alertCase.title
        bodyLabel.text = alertCase.body
        setButtons(with: alertCase)
        layoutToSuperview(superview, with: alertCase)
    }
    
    private func setButtons(with alertCase: FocusAlertCase) {
        setPrimaryButton(with: alertCase)
        setSecondaryButton(with: alertCase)
        setupUI()
    }
    
    private func setPrimaryButton(with alertCase: FocusAlertCase) {
        primaryButton = ButtonComponent(title: alertCase.primaryButtonTitle, cornerRadius: 28)
        primaryButton?.addTarget(self.delegate, action: alertCase.primaryButtonAction, for: .touchUpInside)
        primaryButton?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setSecondaryButton(with alertCase: FocusAlertCase) {
        secondaryButton = ButtonComponent(title: alertCase.secondaryButtonTitle, textColor: .label, cornerRadius: 28)
        secondaryButton?.backgroundColor = .clear
        secondaryButton?.layer.borderColor = UIColor.label.cgColor
        secondaryButton?.layer.borderWidth = 1
        secondaryButton?.addTarget(self.delegate, action: alertCase.secondaryButtonAction, for: .touchUpInside)
        secondaryButton?.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension FocusAlertView: ViewCodeProtocol {
    func setupUI() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        guard let primaryButton,
              let secondaryButton else { return }
        
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(primaryButton)
        addSubview(secondaryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            
            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 290 / 360),
            
            secondaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 360),
            secondaryButton.heightAnchor.constraint(equalTo: primaryButton.widthAnchor, multiplier: 55 / 160),
            secondaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            
            primaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 160 / 360),
            primaryButton.heightAnchor.constraint(equalTo: primaryButton.widthAnchor, multiplier: 55 / 160),
            primaryButton.leadingAnchor.constraint(equalTo: secondaryButton.trailingAnchor, constant: 12),
            primaryButton.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor),
        ])
    }
    
    private func layoutToSuperview(_ superview: UIView, with alertCase: FocusAlertCase) {
        self.removeFromSuperview()
        
        superview.addSubview(self)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 366 / 390),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 228 / 366),
        ])
        
        switch alertCase.position {
            case .mid:
                centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -25).isActive = true
        }
    }
}
