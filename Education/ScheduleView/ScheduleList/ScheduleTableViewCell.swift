//
//  ScheduleTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

protocol ScheduleButtonDelegate: AnyObject {
    func didTapCircleView(in cell: ScheduleTableViewCell)
}

class ScheduleTableViewCell: UITableViewCell {
    // MARK: - ID
    static let identifier = "scheduleCell"
    weak var delegate: ScheduleButtonDelegate?
    
    // MARK: - Properties
    var subject: Subject? {
        didSet {
            guard let subject = subject else { return }
            
            self.subjectNameLabel.text = subject.unwrappedName
        }
    }
    
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else { return }
            
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
                self.circleView.isHidden = true
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
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(circleViewTapped))
        circleView.addGestureRecognizer(tapGestureRecognizer)
        circleView.isUserInteractionEnabled = true
    }

    @objc private func circleViewTapped() {
        delegate?.didTapCircleView(in: self)
    }
    
    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            
            self.cardView.backgroundColor = color
        }
    }
    
    // MARK: - UI Components
    private let cardView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    let playImageView: UIImageView = {
        let playImage = UIImage(systemName: "play.fill")!
        let imageView = UIImageView(image: playImage)
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let timeLeftLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textAlignment = .right
        lbl.text = "Falta 10 mins"
        lbl.textColor = .white
//        lbl.font = .boldSystemFont(ofSize: 18.0)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let subjectNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .boldSystemFont(ofSize: 20.0)
        
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
        self.setupGestureRecognizer()
    }
    
    private func getTimeLeft (){
        
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
        cardView.addSubview(circleView)
        cardView.addSubview(timeLeftLabel)
        circleView.addSubview(playImageView)
        
        
        let padding = 8.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding),
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding),
            
            circleView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            circleView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -padding * 2),
            circleView.widthAnchor.constraint(equalToConstant: 50),
            circleView.heightAnchor.constraint(equalToConstant: 50),
            
            timeLeftLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            timeLeftLabel.trailingAnchor.constraint(equalTo: circleView.leadingAnchor, constant: -padding * 2),
            
            subjectNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: padding * 2),
            subjectNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: padding * 2),
            subjectNameLabel.trailingAnchor.constraint(equalTo: timeLeftLabel.leadingAnchor, constant: -padding),
            
            timeLabel.topAnchor.constraint(equalTo: subjectNameLabel.bottomAnchor, constant: (padding / 2)),
            timeLabel.leadingAnchor.constraint(equalTo: subjectNameLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: subjectNameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -padding * 2),
            
            playImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            playImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            
            
        ])
        
        cardView.layer.cornerRadius = 16
    }
}

//Cell UI
extension ScheduleTableViewCell{
    private func resetView() {
        self.circleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.circleView.layer.borderWidth = 0
        self.playImageView.tintColor = .white
        self.cardView.layer.borderWidth = 0
    }

    private func updateViewForUpcomingEvent(startTimeInMinutes: Int, currentTimeInMinutes: Int) {
        let differenceInMinutes = startTimeInMinutes - currentTimeInMinutes
        let hoursLeft = differenceInMinutes / 60
        let minutesLeft = differenceInMinutes % 60
        guard let color = self.color else { return }
        
        self.circleView.isHidden = false
        self.circleView.layer.borderWidth = 0
        self.timeLeftLabel.textColor = color.darker()
        self.timeLeftLabel.font = .systemFont(ofSize: 16)
        self.circleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.cardView.layer.borderWidth = 0
        self.playImageView.tintColor = .white
        self.timeLeftLabel.text = "Em \(hoursLeft)h\(minutesLeft)m"
    }

    private func updateViewForOngoingEvent() {
        guard let color = self.color else { return }
        
        self.circleView.isHidden = false
        self.timeLeftLabel.text = "Agora"
        self.timeLeftLabel.font = .boldSystemFont(ofSize: 16)
        self.timeLeftLabel.textColor = .white
        self.cardView.layer.borderWidth = 1
        self.cardView.layer.borderColor = UIColor.white.cgColor
        self.circleView.backgroundColor = .white
        self.circleView.layer.borderWidth = 3
        self.circleView.layer.borderColor = color.darker()?.cgColor
        self.playImageView.tintColor = color.darker()
        self.circleView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
    }

    private func updateViewForCompletedEvent() {
        guard let color = self.color else { return }
        
        self.circleView.isHidden = false
        self.timeLeftLabel.textColor = color.darker()
        self.playImageView.tintColor = .white
        self.timeLeftLabel.font = .systemFont(ofSize: 16)
        self.cardView.layer.borderWidth = 0
        self.circleView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.circleView.layer.borderWidth = 0
        self.timeLeftLabel.text = "Concluído"
    }
}


extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
