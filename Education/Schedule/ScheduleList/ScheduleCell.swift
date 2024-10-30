//
//  ScheduleCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

#warning("missing dark mode")
class ScheduleCell: UICollectionViewCell {
    // MARK: - ID and Delegate

    static let identifier = "scheduleCell"
    weak var delegate: ScheduleDelegate?

    // MARK: - Properties

    struct CellConfig {
        var subject: Subject?
        var indexPath: IndexPath
        var isDaily: Bool
        var attributedText: NSAttributedString
        var eventCase: EventCase
        var color: UIColor?
    }

    enum EventCase {
        case notToday
        case upcoming(hoursLeft: String, minutesLeft: String)
        case ongoing
        case completed
        case late

        var showsPlayButton: Bool {
            switch self {
            case .notToday, .completed:
                false
            case .upcoming, .ongoing, .late:
                true
            }
        }

        var playButtonStyle: ActivityButton.PlayButtonCase? {
            switch self {
            case .notToday, .completed:
                nil
            case .upcoming, .late:
                .fill
            case .ongoing:
                .stroke
            }
        }

        var attributedText: NSMutableAttributedString {
            let mediumFont = UIFont(name: Fonts.darkModeOnMedium, size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .semibold)
            let semiboldFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)

            switch self {
            case .notToday:
                return NSMutableAttributedString()
            case .upcoming:
                return NSMutableAttributedString(string: getUpcomingString(), attributes: [.font: mediumFont])
            case .ongoing:
                return NSMutableAttributedString(string: String(localized: "timeLeftNow"), attributes: [.font: semiboldFont])
            case .completed:
                let attributedString = getCompletedAttributedString()
                attributedString.addAttributes([.font: mediumFont], range: NSRange(location: 0, length: attributedString.length))
                return attributedString
            case .late:
                return NSMutableAttributedString(string: String(localized: "timeLeftLate"), attributes: [.font: mediumFont])
            }
        }

        private func getUpcomingString() -> String {
            guard case let .upcoming(hoursLeft, minutesLeft) = self else {
                return String()
            }

            if Int(hoursLeft) == 0 {
                return String(format: NSLocalizedString("startsIn", comment: ""), minutesLeft)
            } else {
                return String(format: NSLocalizedString("timeLeft", comment: ""), hoursLeft, minutesLeft)
            }
        }

        private func getCompletedAttributedString() -> NSMutableAttributedString {
            guard case .completed = self else {
                return NSMutableAttributedString()
            }

            let completedString = NSAttributedString(string: String(localized: "timeLeftFinished"))
            let attachmentImage: UIImage = UIImage(systemName: "checkmark") ?? UIImage()
            let attachment = NSTextAttachment(image: attachmentImage)
            let checkmarkString = NSAttributedString(attachment: attachment)
            let attributedString = NSMutableAttributedString()
            attributedString.append(completedString)
            attributedString.append(NSAttributedString(string: "  "))
            attributedString.append(checkmarkString)
            return attributedString
        }
    }

    var config: CellConfig? {
        didSet {
            guard let config,
                  let subject = config.subject else { return }

            subjectNameLabel.text = subject.unwrappedName
            subjectNameLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: config.isDaily ? 17 : 16)
            timeLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: config.isDaily ? 14 : 14)
            timeLabel.attributedText = config.attributedText
            updateView(for: config.eventCase)
            setupUI()
            configure()
        }
    }

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let timeLeftLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var playButton: ActivityButton = {
        let bttn = ActivityButton()
        bttn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        bttn.translatesAutoresizingMaskIntoConstraints = false
        return bttn
    }()

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        config = nil

        for subview in cardView.subviews {
            subview.removeFromSuperview()
        }

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }

    // MARK: - Methods

    private func configure() {
        guard let config,
              let color = config.color else { return }

        cardView.backgroundColor = color.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.2)

        let subjectColor = traitCollection.userInterfaceStyle == .light ? color.darker(by: 0.6) : color.darker(by: 1)
        subjectNameLabel.textColor = subjectColor
        playButton.playImageView.tintColor = subjectColor
        playButton.circleView.backgroundColor = color.withAlphaComponent(0.6)

        var stringColor: UIColor = color

        if case .ongoing = config.eventCase {
            stringColor = color.darker(by: 0.6) ?? color
        }

        if let attributedText = timeLeftLabel.attributedText {
            let timeLeftAttributedString = NSMutableAttributedString(attributedString: attributedText)
            timeLeftAttributedString.addAttributes([.foregroundColor: stringColor], range: NSRange(location: 0, length: timeLeftAttributedString.length))
            timeLeftLabel.attributedText = timeLeftAttributedString
        }
    }

    @objc 
    private func playButtonTapped() {
        guard let config else { return }

        delegate?.playButtonTapped(at: config.indexPath, withColor: config.color)
    }
}

// MARK: - UI Setup

extension ScheduleCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        layoutTimeLeftLabel()
    }

    private func layoutTimeLeftLabel() {
        guard let config else { return }
        let isDaily = config.isDaily
        let eventCase = config.eventCase

        cardView.addSubview(subjectNameLabel)
        cardView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
        ])

        if isDaily {
            cardView.addSubview(timeLeftLabel)

            NSLayoutConstraint.activate([
                subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 9.5),
                subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
                subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -28),

                timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -9.5),

                timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            ])

            if eventCase.showsPlayButton {
                cardView.addSubview(playButton)

                NSLayoutConstraint.activate([
                    timeLeftLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -7),

                    playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 38 / 366),
                    playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
                    playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
                    playButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
                ])
            } else {
                timeLeftLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20).isActive = true
            }
        } else {
            NSLayoutConstraint.activate([
                subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 4),
                subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
                subjectNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -6),

                timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8.5),
                timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: 3),
            ])

            if eventCase.showsPlayButton {
                cardView.addSubview(playButton)

                NSLayoutConstraint.activate([
                    playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 37 / 147),
                    playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
                    playButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8.5),
                ])
            } else {
                if case .completed = eventCase {
                    updateTimeLeftLabel()

                    cardView.addSubview(timeLeftLabel)

                    NSLayoutConstraint.activate([
                        timeLeftLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),
                        timeLeftLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.5),
                    ])
                }
            }
        }
    }
}

// MARK: - Cell UI

extension ScheduleCell {
    private func updateView(for eventCase: EventCase) {
        playButton.isHidden = !eventCase.showsPlayButton
        playButton.styleCase = eventCase.playButtonStyle
        timeLeftLabel.attributedText = eventCase.attributedText
    }

    private func updateTimeLeftLabel() {
        guard let config,
              case .completed = config.eventCase else { return }

        let semiboldFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .semibold)
        let attachmentImage: UIImage = UIImage(systemName: "checkmark") ?? UIImage()
        let attachment = NSTextAttachment(image: attachmentImage)
        let checkmarkString = NSAttributedString(attachment: attachment)
        let attributedString = NSMutableAttributedString()
        attributedString.append(checkmarkString)
        attributedString.addAttributes([.font: semiboldFont, .foregroundColor: config.color ?? UIColor.label], range: NSRange(location: 0, length: attributedString.length))

        timeLeftLabel.attributedText = attributedString
    }
}
