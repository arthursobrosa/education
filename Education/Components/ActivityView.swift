//
//  ActivityView.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit

class ActivityView: UIView {
    // MARK: - Delegate to connect with tab bar

    weak var delegate: TabBarDelegate?

    // MARK: - Properties

    var subject: Subject? {
        didSet {
            if let subject {
                activityTitle.text = subject.unwrappedName
                return
            }

            activityTitle.text = String(localized: "newActivity")
        }
    }

    var timerSeconds: Int? {
        didSet {
            guard let timerSeconds else { return }

            updateTimer(timerSeconds: timerSeconds)
        }
    }

    var color: UIColor? {
        didSet {
            studyingNowLabel.textColor = color?.darker(by: 1.3)
            activityTitle.textColor = color?.darker(by: 0.6)
            activityTimer.textColor = color
            activityBarButton.color = color
        }
    }

    // MARK: - UI Properties

    private let studyingNowLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "studyingNow")
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityTimer: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var activityBarButton: ActivityBarButton = {
        let button = ActivityBarButton()
        button.pauseResumeButton.addTarget(delegate, action: #selector(TabBarDelegate.didTapPlayButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? .tabBg : .systemBackground
        layer.shadowColor = traitCollection.userInterfaceStyle == .dark ? UIColor.tabShadow.cgColor : UIColor.label.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, traitCollection: UITraitCollection) in
            if traitCollection.userInterfaceStyle == .dark {
                self.backgroundColor = .systemBackground
                self.layer.shadowColor = UIColor.label.cgColor
            } else {
                self.backgroundColor = .tabBg
                self.layer.shadowColor = UIColor.tabShadow.cgColor
            }
        }

        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height * (18 / 60)
    }

    // MARK: - Methods

    private func updateTimer(timerSeconds: Int) {
        let seconds = timerSeconds % 60
        let minutes = timerSeconds / 60 % 60
        let hours = timerSeconds / 3600

        let secondsText = getText(from: seconds)
        let minutesText = getText(from: minutes)
        let hoursText = getText(from: hours)

        let timerText = "\(hoursText):\(minutesText):\(secondsText)"

        activityTimer.text = timerText
    }

    private func getText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}

// MARK: - UI Setup

extension ActivityView: ViewCodeProtocol {
    func setupUI() {
        addSubview(studyingNowLabel)
        addSubview(activityTitle)
        addSubview(activityTimer)
        addSubview(activityBarButton)

        NSLayoutConstraint.activate([
            studyingNowLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            studyingNowLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),

            activityTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            activityTitle.leadingAnchor.constraint(equalTo: studyingNowLabel.leadingAnchor),
            activityTitle.trailingAnchor.constraint(equalTo: activityTimer.leadingAnchor, constant: 11),

            activityTimer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 80 / 366),
            activityTimer.centerYAnchor.constraint(equalTo: centerYAnchor),

            activityBarButton.leadingAnchor.constraint(equalTo: activityTimer.trailingAnchor, constant: 13),
            activityBarButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 44 / 366),
            activityBarButton.heightAnchor.constraint(equalTo: activityBarButton.widthAnchor),
            activityBarButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityBarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
}
