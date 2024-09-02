//
//  ScheduleTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    // MARK: - ID
    static let identifier = "scheduleCell"
    weak var delegate: ScheduleDelegate?
    
    // MARK: - Properties
    var indexPath: IndexPath?
    
    var subject: Subject? {
        didSet {
            guard let subject else { return }
            
            self.subjectNameLabel.text = subject.unwrappedName
        }
    }
    
    var schedule: Schedule? {
        didSet {
            guard let schedule else { return }
            
            let dateNow = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let font: UIFont = UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)
            let startTimeColor: UIColor = (self.traitCollection.userInterfaceStyle == .light ? self.color?.darker(by: 0.8) : self.color) ?? .label
            let endTimeColor: UIColor = (self.traitCollection.userInterfaceStyle == .light ? self.color : self.color?.darker(by: 0.8)) ?? .label
            
            let attributedString = NSMutableAttributedString()
            let startTimeString = NSAttributedString(string: "\(formatter.string(from: schedule.unwrappedStartTime))", attributes: [.font : font, .foregroundColor : startTimeColor])
            let endTimeString = NSAttributedString(string: "\(formatter.string(from: schedule.unwrappedEndTime))", attributes: [.font : font, .foregroundColor : endTimeColor])
            
            attributedString.append(startTimeString)
            attributedString.append(NSAttributedString(string: " - ", attributes: [.font : font, .foregroundColor : endTimeColor]))
            attributedString.append(endTimeString)
            
            self.timeLabel.attributedText = attributedString
            
            let calendar = Calendar.current
            let startTimeComponents = calendar.dateComponents([.hour, .minute], from: schedule.unwrappedStartTime)
            let endTimeComponents = calendar.dateComponents([.hour, .minute], from: schedule.unwrappedEndTime)
            let currentTimeComponents = calendar.dateComponents([.hour, .minute], from: dateNow)
            
            guard let startHour = startTimeComponents.hour, let startMinute = startTimeComponents.minute,
                  let endHour = endTimeComponents.hour, let endMinute = endTimeComponents.minute,
                  let currentHour = currentTimeComponents.hour, let currentMinute = currentTimeComponents.minute else {
                return
            }
            
            let startTimeInMinutes = startHour * 60 + startMinute
            let endTimeInMinutes = endHour * 60 + endMinute
            let currentTimeInMinutes = currentHour * 60 + currentMinute
            
            if schedule.dayOfTheWeek != Calendar.current.component(.weekday, from: Date()) - 1 {
                self.resetView()
                self.playButton.isHidden = true
                self.timeLeftLabel.text = ""
                return
            }
            
            //Update cell UI depending on the day and hour
            if currentTimeInMinutes < startTimeInMinutes {
                updateViewForUpcomingEvent(startTimeInMinutes: startTimeInMinutes, currentTimeInMinutes: currentTimeInMinutes)
            } else if currentTimeInMinutes <= endTimeInMinutes {
                updateViewForOngoingEvent()
            } else {
                updateViewForCompletedEvent()
            }
        }
    }

    @objc private func playButtonTapped() {
        self.delegate?.playButtonTapped(at: self.indexPath, withColor: self.color)
    }
    
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
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 17)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        
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
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension ScheduleTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(cardView)
        cardView.addSubview(subjectNameLabel)
        cardView.addSubview(timeLabel)
        cardView.addSubview(timeLeftLabel)
        cardView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.5),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5.5),
            
            playButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: (48/366)),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
            
            timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            timeLeftLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -7),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 9.5),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -28),
            
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -9.5)
        ])
        
        cardView.layer.cornerRadius = 16
    }
}

// MARK: - Cell UI
extension ScheduleTableViewCell{
    private func resetView() {
        self.cardView.layer.borderWidth = 0
    }

    private func updateViewForUpcomingEvent(startTimeInMinutes: Int, currentTimeInMinutes: Int) {
        let differenceInMinutes = startTimeInMinutes - currentTimeInMinutes
        let hoursLeft = differenceInMinutes / 60
        let minutesLeft = differenceInMinutes % 60
        
        self.playButton.isHidden = false
        self.timeLeftLabel.text = String(format: NSLocalizedString("timeLeft", comment: ""), String(hoursLeft), String(minutesLeft))
    }

    private func updateViewForOngoingEvent() {
        self.playButton.isHidden = false
        self.timeLeftLabel.text = String(localized: "timeLeftNow")
    }

    private func updateViewForCompletedEvent() {
        self.playButton.isHidden = false
        self.timeLeftLabel.text = String(localized: "timeLeftFinished")
    }
}
