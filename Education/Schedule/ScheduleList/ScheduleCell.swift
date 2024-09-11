//
//  ScheduleCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    // MARK: - ID and Delegate
    static let identifier = "scheduleCell"
    weak var delegate: ScheduleDelegate?
    
    // MARK: - Properties
    enum EventCase {
        case notToday
        case upcoming(hoursLeft: String, minutesLeft: String)
        case ongoing
        case completed
        
        var showsPlayButton: Bool {
            switch self {
                case .notToday:
                    return false
                default:
                    return true
            }
        }
        
        var timeLeftText: String {
            switch self {
                case .upcoming(let hoursLeft, let minutesLeft):
                    return String(format: NSLocalizedString("timeLeft", comment: ""), hoursLeft, minutesLeft)
                case .ongoing:
                    return String(localized: "timeLeftNow")
                case .completed:
                    return String(localized: "timeLeftFinished")
                default:
                    return String()
            }
        }
    }
    
    var isDaily: Bool? {
        didSet {
            self.setupUI()
            
            guard let isDaily else { return }
            
            self.subjectNameLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: isDaily ? 17 : 14)
            
            self.timeLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: isDaily ? 14 : 10)
        }
    }
    
    var indexPath: IndexPath?
    
    var color: UIColor? {
        didSet {
            guard let color else { return }
            
            self.cardView.backgroundColor = color.withAlphaComponent(0.2)
            
            let subjectColor = self.traitCollection.userInterfaceStyle == .light ? color.darker(by: 0.6) : color.darker(by: 1.8)
            self.subjectNameLabel.textColor = subjectColor
            self.playButton.playImageView.tintColor = subjectColor
            self.playButton.circleView.backgroundColor = color.withAlphaComponent(0.6)
            self.timeLeftLabel.textColor = self.traitCollection.userInterfaceStyle == .light ? color : color.darker(by: 0.8)
        }
    }
    
    var subject: Subject? {
        didSet {
            guard let subject else { return }
            
            self.subjectNameLabel.text = subject.unwrappedName
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
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timeLeftLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.font = UIFont(name: Fonts.darkModeOnMedium, size: 13)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var playButton: ActivityButton = {
        let bttn = ActivityButton()
        
        bttn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    // MARK: - Methods
    func configure(with attributedString: NSAttributedString, and eventCase: EventCase) {
        self.timeLabel.attributedText = attributedString
        
        self.updateView(for: eventCase)
    }
    
    @objc private func playButtonTapped() {
        self.delegate?.playButtonTapped(at: self.indexPath, withColor: self.color)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

// MARK: - UI Setup
extension ScheduleCell: ViewCodeProtocol {
    func setupUI() {
        guard let isDaily else { return }
        
        self.contentView.addSubview(cardView)
        cardView.addSubview(subjectNameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 9.5),
            
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            
            playButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor)
        ])
        
        if isDaily {
            cardView.addSubview(timeLeftLabel)
            
            NSLayoutConstraint.activate([
                subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
                subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -28),
                
                timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
                timeLeftLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -7),
                
                timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -9.5),
                
                playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: (38/366)),
                playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            ])
        } else {
            NSLayoutConstraint.activate([
                subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
                subjectNameLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -6),
                
                timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8.5),
                
                playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: (30/147)),
                playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            ])
        }
    }
}

// MARK: - Cell UI
extension ScheduleCell {
    private func updateView(for eventCase: EventCase) {
        self.playButton.isHidden = !eventCase.showsPlayButton
        self.timeLeftLabel.text = eventCase.timeLeftText
    }
}
