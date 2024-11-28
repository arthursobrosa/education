//
//  ScheduleCellConfiguration.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/11/24.
//

import UIKit

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
        guard case let .upcoming(hoursLeft, minutesLeft) = self,
              let hours = Int(hoursLeft),
              let minutes = Int(minutesLeft) else {
            
            return String()
        }

        if hours == 0 {
            return String(format: NSLocalizedString("startsIn", comment: ""), minutesLeft, "min")
        } else {
            if minutes == 0 {
                return String(format: NSLocalizedString("startsIn", comment: ""), hoursLeft, "h")
            }
            
            if minutes < 10 {
                let minutesString = "0" + minutesLeft
                return String(format: NSLocalizedString("timeLeft", comment: ""), hoursLeft, minutesString)
            }
            
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

protocol ScheduleCellProtocol: AnyObject, ViewCodeProtocol {
    // MARK: - Properties
    
    var delegate: (any ScheduleDelegate)? { get set }
    var config: CellConfig? { get set }
    
    // MARK: - UI Properties
    
    var cardView: UIView? { get set }
    var subjectNameLabel: UILabel? { get set }
    var timeLabel: UILabel? { get set }
    var timeLeftLabel: UILabel? { get set }
    var playButton: ActivityButton? { get set }
    
    // MARK: - Methods
    
    func configure(with passedInConfig: CellConfig, traitCollection: UITraitCollection)
    func setupSubviews()
}

extension ScheduleCellProtocol {
    func setupSubviews() {
        cardView = {
            let view = UIView()
            view.layer.cornerRadius = 16
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        subjectNameLabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        timeLabel = {
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        timeLeftLabel = {
            let lbl = UILabel()
            lbl.textAlignment = .right
            lbl.translatesAutoresizingMaskIntoConstraints = false
            return lbl
        }()
        
        playButton = {
            let bttn = ActivityButton()
            bttn.addTarget(delegate, action: #selector(ScheduleDelegate.playButtonTapped(_:)), for: .touchUpInside)
            bttn.translatesAutoresizingMaskIntoConstraints = false
            return bttn
        }()
    }
    
    func configure(with passedInConfig: CellConfig, traitCollection: UITraitCollection) {
        config = passedInConfig
        guard let config,
              let subject = config.subject else { return }

        /// Initial configuration
        playButton?.focusConfig = (indexPath: config.indexPath, color: config.color, isDaily: config.isDaily)
        subjectNameLabel?.text = subject.unwrappedName
        subjectNameLabel?.font = UIFont(name: Fonts.darkModeOnSemiBold, size: config.isDaily ? 17 : 16)
        timeLabel?.font = UIFont(name: Fonts.darkModeOnSemiBold, size: config.isDaily ? 14 : 14)
        timeLabel?.attributedText = config.attributedText
        
        /// Updating views based on eventCase
        let eventCase = config.eventCase
        playButton?.isHidden = !eventCase.showsPlayButton
        playButton?.styleCase = eventCase.playButtonStyle
        timeLeftLabel?.attributedText = eventCase.attributedText
        
        /// configure subviews based on config's color
        guard let color = config.color else { return }
//        cardView?.backgroundColor = color.withAlphaComponent(traitCollection.userInterfaceStyle == .dark ? 0.3 : 0.2)
        cardView?.backgroundColor = color.withAlphaComponent(0.3)

//        let subjectColor = traitCollection.userInterfaceStyle == .light ? color.darker(by: 0.6) : color.darker(by: 1)
        let subjectColor = color.darker(by: 0.6)
        subjectNameLabel?.textColor = traitCollection.userInterfaceStyle == .dark ? color : subjectColor
        playButton?.playImageView.tintColor = color
        playButton?.circleView.backgroundColor = color.withAlphaComponent(0.5)

        var stringColor: UIColor = color

        if case .ongoing = config.eventCase {
            stringColor = traitCollection.userInterfaceStyle == .dark ? color : color.darker(by: 0.6) ?? color
        }

        if let attributedText = timeLeftLabel?.attributedText {
            let timeLeftAttributedString = NSMutableAttributedString(attributedString: attributedText)
            timeLeftAttributedString.addAttributes([.foregroundColor: stringColor], range: NSRange(location: 0, length: timeLeftAttributedString.length))
            timeLeftLabel?.attributedText = timeLeftAttributedString
        }
        
        /// Setup UI
        setupUI()
    }
}
