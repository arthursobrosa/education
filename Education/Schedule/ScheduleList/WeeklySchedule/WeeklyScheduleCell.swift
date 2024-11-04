//
//  WeeklyScheduleCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class WeeklyScheduleCell: UICollectionViewCell, ScheduleCellProtocol {
    // MARK: - ID and Delegate
    
    static let identifier = "weeklyScheduleCell"
    weak var delegate: ScheduleDelegate?

    // MARK: - Properties

    var config: CellConfig?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components

    var cardView: UIView?
    var subjectNameLabel: UILabel?
    var timeLabel: UILabel?
    var timeLeftLabel: UILabel?
    var playButton: ActivityButton?

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        config = nil
        
        if let cardView {
            for subview in cardView.subviews {
                subview.removeFromSuperview()
            }
        }

        for subview in contentView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    // MARK: - Methods
    
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

        timeLeftLabel?.attributedText = attributedString
    }
}

// MARK: - UI Setup

extension WeeklyScheduleCell: ViewCodeProtocol {
    func setupUI() {
        guard let cardView,
              let subjectNameLabel,
              let timeLabel,
              let timeLeftLabel,
              let eventCase = config?.eventCase else {
            
            return
                  
        }
        
        contentView.addSubview(cardView)
        cardView.addSubview(subjectNameLabel)
        cardView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8.5),
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: 3),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 4),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            subjectNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -6),
        ])
        
        if eventCase.showsPlayButton {
            guard let playButton else { return }
            
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
