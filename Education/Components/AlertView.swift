//
//  AlertView.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

enum AlertPosition {
    case top
    case mid
    case bottom
}

enum AlertCase {
    case restartingCase
    case finishingEarlyCase
    case finishingTimerCase(subject: Subject?)
    case finishingPomodoroCase(pomodoroString: String, isAtWorkTime: Bool)
    
    case deletingSchedule(subject: Subject)
    
    case discardingFocusSession
    case deletingFocusSession
    case deletingOtherFocusSession
    
    case deletingSubject(subjectName: String)
    
    case deletingTheme

    var title: String {
        switch self {
        case .restartingCase:
            String(localized: "restartAlertTitle")
        case .finishingEarlyCase:
            String(localized: "finishEarlyAlertTitle")
        case .finishingTimerCase:
            String(localized: "finishTimerAlertTitle")
        case let .finishingPomodoroCase(pomodoroString, _):
            String(format: NSLocalizedString("finishPomodoroAlertTitle", comment: ""), pomodoroString)
        case .deletingSchedule:
            String(localized: "deleteScheduleAlertTitle")
        case .discardingFocusSession:
            String(localized: "discardingFocusSessionAlertTitle")
        case .deletingFocusSession:
            String(localized: "deletingFocusSessionAlertTitle")
        case .deletingOtherFocusSession:
            String(localized: "deletingOtherFocusSessionAlertTitle")
        case .deletingSubject:
            String(localized: "deleteSubjectTitle")
        case .deletingTheme:
            String(localized: "deletingThemeAlertTitle")
        }
    }

    var body: String {
        switch self {
        case .restartingCase:
            String(localized: "restartAlertBody")
        case .finishingEarlyCase:
            String(localized: "finishEarlyAlertBody")
        case .finishingTimerCase:
            getFinishTimerAlertBody()
        case .finishingPomodoroCase:
            getFinishPomodoroAlertBody()
        case .deletingSchedule(let subject):
            String(
                format: NSLocalizedString("deleteScheduleAlertBody", comment: ""),
                String(subject.unwrappedName.prefix(20))
            )
        case .discardingFocusSession:
            String(localized: "discardingFocusSessionAlertBody")
        case .deletingFocusSession:
            String(localized: "deletingFocusSessionAlertMessage")
        case .deletingOtherFocusSession:
            String(localized: "deletingOtherFocusSessionAlertMessage")
        case .deletingSubject(let subjectName):
            String(
                format: NSLocalizedString("deleteSubjectMessage", comment: ""),
                String(subjectName.prefix(20))
            )
        case .deletingTheme:
            String(localized: "deletingThemeAlertMessage")
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .restartingCase:
            String(localized: "yes")
        case .finishingEarlyCase:
            String(localized: "yes")
        case .finishingTimerCase:
            String(localized: "focusFinish")
        case .finishingPomodoroCase(_, let isAtWorkTime):
            if isAtWorkTime {
                String(localized: "startInterval")
            } else {
                String(localized: "startFocus")
            }
        case .deletingSchedule:
            String(localized: "yes")
        case .discardingFocusSession:
            String(localized: "yes")
        case .deletingFocusSession:
            String(localized: "yes")
        case .deletingOtherFocusSession:
            String(localized: "yes")
        case .deletingSubject:
            String(localized: "yes")
        case .deletingTheme:
            String(localized: "yes")
        }
    }
    
    var secondaryButtonTitle: String {
        switch self {
        case .restartingCase:
            String(localized: "cancel")
        case .finishingEarlyCase:
            String(localized: "cancel")
        case .finishingTimerCase:
            String(localized: "extendTime")
        case let .finishingPomodoroCase(_, isAtWorkTime):
            if isAtWorkTime {
                String(localized: "extendFocus")
            } else {
                String(localized: "extendInterval")
            }
        case .deletingSchedule:
            String(localized: "cancel")
        case .discardingFocusSession:
            String(localized: "cancel")
        case .deletingFocusSession:
            String(localized: "cancel")
        case .deletingOtherFocusSession:
            String(localized: "cancel")
        case .deletingSubject:
            String(localized: "cancel")
        case .deletingTheme:
            String(localized: "cancel")
        }
    }
    
    var primaryButtonAction: Selector {
        switch self {
        case .restartingCase:
            #selector(FocusSessionDelegate.didRestart)
        case .finishingEarlyCase:
            #selector(FocusSessionDelegate.didFinish)
        case .finishingTimerCase:
            #selector(FocusSessionDelegate.didFinish)
        case .finishingPomodoroCase:
            #selector(FocusSessionDelegate.didStartNextPomodoro)
        case .deletingSchedule:
            #selector(ScheduleDelegate.didDeleteSchedule)
        case .discardingFocusSession:
            #selector(FocusEndDelegate.didDiscard)
        case .deletingFocusSession:
            #selector(FocusSubjectDetailsDelegate.didDelete)
        case .deletingOtherFocusSession:
            #selector(SubjectDetailsDelegate.didDelete)
        case .deletingSubject:
            #selector(SubjectCreationDelegate.didDelete)
        case .deletingTheme:
            #selector(ThemeListDelegate.didDeleteTheme)
        }
    }

    var secondaryButtonAction: Selector {
        switch self {
        case .restartingCase:
            #selector(FocusSessionDelegate.didCancel)
        case .finishingEarlyCase:
            #selector(FocusSessionDelegate.didCancel)
        case .finishingTimerCase:
            #selector(FocusSessionDelegate.didTapExtendButton)
        case .finishingPomodoroCase:
            #selector(FocusSessionDelegate.didTapExtendButton)
        case .deletingSchedule:
            #selector(ScheduleDelegate.didCancelDeletion)
        case .discardingFocusSession:
            #selector(FocusEndDelegate.didCancel)
        case .deletingFocusSession:
            #selector(FocusSubjectDetailsDelegate.didCancelDeletion)
        case .deletingOtherFocusSession:
            #selector(SubjectDetailsDelegate.didCancel)
        case .deletingSubject:
            #selector(SubjectCreationDelegate.didCancel)
        case .deletingTheme:
            #selector(ThemeListDelegate.didCancel)
        }
    }
    
    var position: AlertPosition {
        switch self {
        case .restartingCase:
            .bottom
        case .finishingEarlyCase:
            .bottom
        case .finishingTimerCase:
            .mid
        case .finishingPomodoroCase:
            .mid
        case .deletingSchedule:
            .mid
        case .discardingFocusSession:
            .bottom
        case .deletingFocusSession:
            .bottom
        case .deletingOtherFocusSession:
            .mid
        case .deletingSubject:
            .bottom
        case .deletingTheme:
            .mid
        }
    }

    private func getFinishTimerAlertBody() -> String {
        guard case let .finishingTimerCase(subject) = self else { return String() }

        if let subject {
            return String(format: NSLocalizedString("finishTimerAlertBody", comment: ""), String(subject.unwrappedName.prefix(20)))
        } else {
            return String(localized: "finishTimerAlertBody-noSubject")
        }
    }

    private func getFinishPomodoroAlertBody() -> String {
        guard case let .finishingPomodoroCase(pomodoroString, _) = self else {
            return String()
        }

        return String(format: NSLocalizedString("finishPomodoroAlertBody", comment: ""), pomodoroString)
    }
}

class AlertView: UIView {
    // MARK: - Properties
    
    struct AlertConfig {
        var title: String
        var body: String
        var primaryButtonTitle: String
        var secondaryButtonTitle: String
        var superView: UIView
        var position: AlertPosition
        
        static func getAlertConfig(with alertCase: AlertCase, superview: UIView) -> AlertConfig {
            AlertConfig(
                title: alertCase.title,
                body: alertCase.body,
                primaryButtonTitle: alertCase.primaryButtonTitle,
                secondaryButtonTitle: alertCase.secondaryButtonTitle,
                superView: superview,
                position: alertCase.position
            )
        }
    }
    
    var config: AlertConfig? {
        didSet {
            guard let config else { return }
            
            titleLabel.text = config.title
            bodyLabel.text = config.body
            setButtons()
            layoutToSuperview(config.superView, position: config.position)
        }
    }
    
    // MARK: UI Properties

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
    
    private var secondaryButton: ButtonComponent?
    private var primaryButton: ButtonComponent?
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .systemBackground
        layer.cornerRadius = 24

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setButtons() {
        setPrimaryButton()
        setSecondaryButton()
        setupUI()
    }
    
    private func setPrimaryButton() {
        guard let config else { return }
        
        primaryButton = ButtonComponent(title: config.primaryButtonTitle, cornerRadius: 28)
        primaryButton?.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        primaryButton?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setSecondaryButton() {
        guard let config else { return }
        
        secondaryButton = ButtonComponent(title: config.secondaryButtonTitle, textColor: .systemText80, cornerRadius: 28)
        secondaryButton?.backgroundColor = .clear
        secondaryButton?.layer.borderColor = UIColor.buttonNormal.cgColor
        secondaryButton?.layer.borderWidth = 1
        secondaryButton?.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        secondaryButton?.translatesAutoresizingMaskIntoConstraints = false
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.secondaryButton?.layer.borderColor = UIColor.buttonNormal.cgColor
        }
    }
    
    func setPrimaryButtonTarget(_ target: Any?, action: Selector) {
        primaryButton?.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setSecondaryButtonTarget(_ target: Any?, action: Selector) {
        secondaryButton?.addTarget(target, action: action, for: .touchUpInside)
    }
}

// MARK: - UI Setup

extension AlertView: ViewCodeProtocol {
    func setupUI() {
        for subview in subviews {
            subview.removeFromSuperview()
        }

        guard let secondaryButton,
              let primaryButton else { return }

        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(secondaryButton)
        addSubview(primaryButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),

            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 290 / 360),

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
    
    private func layoutToSuperview(_ superview: UIView, position: AlertPosition) {
        removeFromSuperview()

        superview.addSubview(self)

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 366 / 390),
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: 228 / 366),
        ])

        switch position {
        case .top:
            topAnchor.constraint(equalTo: superview.topAnchor, constant: 25).isActive = true
        case .mid:
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        case .bottom:
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -25).isActive = true
        }
    }
}
