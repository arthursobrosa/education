//
//  ScheduleNotificationNameCard.swift
//  Education
//
//  Created by Lucas Cunha on 14/08/24.
//

import UIKit

class ScheduleNotificationNameCard: UIView {
    private let subjectName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnBold, size: 21)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bracket: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal1")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    private let startTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 20)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let lineStartTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    private let endTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnMedium, size: 20)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let lineEndTime: UIImageView = {
        let img = UIImage(named: "ScheduleDetailsModal2")!.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView(image: img)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    init(startTime: String, endTime: String, subjectName: String, dayOfWeek: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.subjectName.text = subjectName
        self.subjectName.textColor = color.darker(by: 0.6)
        
        self.setDayLabel(withColor: color, and: dayOfWeek)
        
        self.bracket.tintColor = color.darker(by: 0.6)
        
        self.startTime.text = startTime
        self.startTime.textColor = color.darker(by: 0.8)
        
        self.lineStartTime.tintColor = color.darker(by: 0.6)
        
        self.endTime.text = endTime
        self.endTime.textColor = color
        
        self.lineEndTime.tintColor = color.darker(by: 0.6)
        
        self.backgroundColor = color.withAlphaComponent(0.2)
        
        self.setupUI()
        
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDayLabel(withColor color: UIColor, and dayOfWeek: String) {
        let attributedString = NSMutableAttributedString()
        
        let darkerColor = color.darker(by: 0.8) ?? .label
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(darkerColor)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 20, height: 20)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let dayString = NSAttributedString(string: dayOfWeek, attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 15) ?? UIFont.systemFont(ofSize: 15, weight: .medium), .foregroundColor : darkerColor, .baselineOffset : 2])
        
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(dayString)
        
        self.dayLabel.attributedText = attributedString
    }
}

extension ScheduleNotificationNameCard: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(subjectName)
        self.addSubview(dayLabel)
        self.addSubview(bracket)
        self.addSubview(startTime)
        self.addSubview(lineStartTime)
        self.addSubview(endTime)
        self.addSubview(lineEndTime)
        
        NSLayoutConstraint.activate([
            subjectName.topAnchor.constraint(equalTo: self.topAnchor, constant: 28),
            subjectName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            
            dayLabel.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            dayLabel.topAnchor.constraint(equalTo: subjectName.bottomAnchor, constant: 16),
            
            bracket.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 53/220),
            bracket.widthAnchor.constraint(equalTo: bracket.heightAnchor, multiplier: 6/53),
            bracket.leadingAnchor.constraint(equalTo: subjectName.leadingAnchor),
            bracket.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 42),
            
            startTime.leadingAnchor.constraint(equalTo: bracket.trailingAnchor, constant: 10),
            startTime.centerYAnchor.constraint(equalTo: bracket.topAnchor),
            
            lineStartTime.centerYAnchor.constraint(equalTo: startTime.centerYAnchor),
            lineStartTime.leadingAnchor.constraint(equalTo: startTime.trailingAnchor, constant: 10),
            
            endTime.leadingAnchor.constraint(equalTo: startTime.leadingAnchor),
            endTime.centerYAnchor.constraint(equalTo: bracket.bottomAnchor),
            
            lineEndTime.centerYAnchor.constraint(equalTo: endTime.centerYAnchor),
            lineEndTime.leadingAnchor.constraint(equalTo: lineStartTime.leadingAnchor)
        ])
    }
}

