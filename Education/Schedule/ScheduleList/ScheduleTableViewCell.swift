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
            
            self.timeLabel.text = "\(formatter.string(from: schedule.unwrappedStartTime)) - \(formatter.string(from: schedule.unwrappedEndTime))"
            self.timeLabel.textColor = .white
            
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
                resetView()
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
            
            self.cardView.backgroundColor = color
        }
    }
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playButton: ActivityButton = {
        let bttn = ActivityButton()
        bttn.activityState = .normal
        
        bttn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private let timeLeftLabel: UILabel = {
        let lbl = UILabel()
        let font = UIFont(name: Fonts.darkModeOnSemiBold, size: 20)
        lbl.font = font
        lbl.textAlignment = .right
        lbl.textColor = .white
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        let font = UIFont(name: Fonts.darkModeOnSemiBold, size: 20)
        lbl.font = font
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
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
        
        let padding = 8.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding),
            
            playButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding * 2),
            playButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: (52/359)),
            playButton.heightAnchor.constraint(equalTo: playButton.widthAnchor),
            
            timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            timeLeftLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -padding * 2),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding * 2),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding * 2),
            subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -padding),
            
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: (padding / 2)),
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding * 2),
        ])
        
        cardView.layer.cornerRadius = 16
    }
}

// MARK: - Cell UI
extension ScheduleTableViewCell{
    private func resetView() {
        self.playButton.activityState = .normal
        self.cardView.layer.borderWidth = 0
    }

    private func updateViewForUpcomingEvent(startTimeInMinutes: Int, currentTimeInMinutes: Int) {
        let differenceInMinutes = startTimeInMinutes - currentTimeInMinutes
        let hoursLeft = differenceInMinutes / 60
        let minutesLeft = differenceInMinutes % 60
        guard let color else { return }
        
        self.playButton.isHidden = false
        self.playButton.activityState = .normal
        self.timeLeftLabel.textColor = color.darker(by: 0.6)
        self.timeLeftLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        self.cardView.layer.borderWidth = 0
        self.timeLeftLabel.text = String(format: NSLocalizedString("timeLeft", comment: ""), String(hoursLeft), String(minutesLeft))
    }

    private func updateViewForOngoingEvent() {
        guard let color else { return }
        
        self.playButton.isHidden = false
        self.playButton.activityState = .current(color: color.darker(by: 0.6))
        self.timeLeftLabel.text = String(localized: "timeLeftNow")
        self.timeLeftLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        self.timeLeftLabel.textColor = .white
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.label.cgColor
    }

    private func updateViewForCompletedEvent() {
        guard let color else { return }
        
        self.playButton.isHidden = false
        self.playButton.activityState = .normal
        self.timeLeftLabel.textColor = color.darker(by: 0.6)
        self.timeLeftLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        self.timeLeftLabel.text = String(localized: "timeLeftFinished")
        self.cardView.layer.borderWidth = 0
    }
}
