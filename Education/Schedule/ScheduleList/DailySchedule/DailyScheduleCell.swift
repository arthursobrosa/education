//
//  DailyScheduleCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/11/24.
//

import UIKit

class DailyScheduleCell: UITableViewCell, ScheduleCellProtocol {
    // MARK: - ID and Delegate
    
    static let identifier = "dailyScheduleCell"
    weak var delegate: ScheduleDelegate?
    
    // MARK: - Properties
    
    var config: CellConfig?
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
}

// MARK: - Setup UI

extension DailyScheduleCell: ViewCodeProtocol {
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
        cardView.addSubview(timeLeftLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -9.5),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 9.5),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -28),

            timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
        
        if eventCase.showsPlayButton {
            guard let playButton else { return }
            
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
    }
}
