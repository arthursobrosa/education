//
//  FocusStatusAlertView.swift
//  Education
//
//  Created by Lucas Cunha on 02/09/24.
//

import UIKit

enum FocusStatusAlertCase {
    case restartingCase
    case finishingEarlyCase
    case finishingTimerCase(subject: Subject?)
    case finishingPomodoroCase(pomodoroString: String, isAtWorkTime: Bool)

    enum AlertPosition {
        case mid
        case bottom
    }

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
        }
    }

    var secondaryButtonTitle: String {
        switch self {
        case .restartingCase, .finishingEarlyCase:
            String(localized: "cancel")
        case .finishingTimerCase:
            String(localized: "extendTime")
        case let .finishingPomodoroCase(_, isAtWorkTime):
            isAtWorkTime ? String(localized: "extendFocus") : String(localized: "extendInterval")
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .restartingCase, .finishingEarlyCase:
            String(localized: "yes")
        case .finishingTimerCase:
            String(localized: "focusFinish")
        case let .finishingPomodoroCase(_, isAtWorkTime):
            isAtWorkTime ? String(localized: "startInterval") : String(localized: "startFocus")
        }
    }

    var secondaryButtonAction: Selector {
        switch self {
        case .restartingCase, .finishingEarlyCase:
            #selector(FocusSessionDelegate.didCancel)
        case .finishingTimerCase, .finishingPomodoroCase:
            #selector(FocusSessionDelegate.didTapExtendButton)
        }
    }

    var primaryButtonAction: Selector {
        switch self {
        case .restartingCase:
            #selector(FocusSessionDelegate.didRestart)
        case .finishingEarlyCase, .finishingTimerCase:
            #selector(FocusSessionDelegate.didFinish)
        case .finishingPomodoroCase:
            #selector(FocusSessionDelegate.didStartNextPomodoro)
        }
    }

    var position: AlertPosition {
        switch self {
        case .restartingCase, .finishingEarlyCase:
            .bottom
        case .finishingTimerCase, .finishingPomodoroCase:
            .mid
        }
    }

    private func getFinishTimerAlertBody() -> String {
        guard case let .finishingTimerCase(subject) = self else { return String() }

        if let subject {
            return String(format: NSLocalizedString("finishTimerAlertBody", comment: ""), subject.unwrappedName)
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

class FocusStatusAlertView: UIView {
    // MARK: - Delegate

    weak var delegate: (any FocusSessionDelegate)?

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
        layer.cornerRadius = 12

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func configure(with focusStatusCase: FocusStatusAlertCase, atSuperview superview: UIView) {
        titleLabel.text = focusStatusCase.title
        bodyLabel.text = focusStatusCase.body
        setButtons(with: focusStatusCase)
        layoutToSuperview(superview, with: focusStatusCase)
    }

    private func setButtons(with alertCase: FocusStatusAlertCase) {
        setSecondaryButton(with: alertCase)
        setPrimaryButton(with: alertCase)
        setupUI()
    }

    private func setSecondaryButton(with alertCase: FocusStatusAlertCase) {
        secondaryButton = ButtonComponent(title: alertCase.secondaryButtonTitle, textColor: .label, cornerRadius: 28)
        secondaryButton?.backgroundColor = .clear
        secondaryButton?.layer.borderColor = UIColor.label.cgColor
        secondaryButton?.layer.borderWidth = 1
        secondaryButton?.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        secondaryButton?.addTarget(delegate, action: alertCase.secondaryButtonAction, for: .touchUpInside)
        secondaryButton?.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setPrimaryButton(with alertCase: FocusStatusAlertCase) {
        primaryButton = ButtonComponent(title: alertCase.primaryButtonTitle, cornerRadius: 28)
        primaryButton?.addTarget(delegate, action: alertCase.primaryButtonAction, for: .touchUpInside)
        primaryButton?.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        primaryButton?.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - UI Setup

extension FocusStatusAlertView: ViewCodeProtocol {
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

    private func layoutToSuperview(_ superview: UIView, with alertCase: FocusStatusAlertCase) {
        removeFromSuperview()

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
