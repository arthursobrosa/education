//
//  ScheduleNotificationView.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationView: UIView {
    weak var delegate: ScheduleNotificationDelegate?

    private let startTime: String
    private let endTime: String
    private let subjectName: String
    private let dayOfWeek: String
    private var color: UIColor?

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)

        button.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "onTimeTitle")
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        let message = String(localized: "onTimeMessage")
        label.text = "\(message) 🕒"
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var scheduleNotificationCardView: ScheduleNotificationNameCard = {
        let unwrappedColor: UIColor = color ?? .red
        let view = ScheduleNotificationNameCard(startTime: startTime, endTime: endTime, subjectName: subjectName, dayOfWeek: dayOfWeek, color: unwrappedColor)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var startButton: ButtonComponent = {
        let attributedText = NSMutableAttributedString(string: String(localized: "startNowButton"))

        let symbolAttachment = NSTextAttachment()
        let symbolImage = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        symbolAttachment.image = symbolImage
        symbolAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)

        let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)

        attributedText.append(NSAttributedString(string: "   "))
        attributedText.append(symbolAttributedString)

        let bttn = ButtonComponent(attrString: attributedText, cornerRadius: 28)

        bttn.tintColor = .label

        bttn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    init(startTime: String, endTime: String, color: UIColor?, subjectName: String, dayOfWeek: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
        self.subjectName = subjectName
        self.dayOfWeek = dayOfWeek

        super.init(frame: .zero)

        setupUI()

        backgroundColor = .systemBackground
        layer.cornerRadius = 14
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc 
    private func didTapStartButton() {
        delegate?.startButtonTapped()
    }

    @objc 
    private func didDismiss() {
        delegate?.dismiss()
    }
}

extension ScheduleNotificationView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(scheduleNotificationCardView)
        addSubview(startButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            titleLabel.topAnchor.constraint(equalTo: closeButton.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            scheduleNotificationCardView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            scheduleNotificationCardView.heightAnchor.constraint(equalTo: scheduleNotificationCardView.widthAnchor, multiplier: 220 / 334),
            scheduleNotificationCardView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scheduleNotificationCardView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),

            startButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 55 / 334),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }
}
