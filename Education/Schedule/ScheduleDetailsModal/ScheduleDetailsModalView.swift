//
//  ScheduleDetailsModalView.swift
//  Education
//
//  Created by Lucas Cunha on 13/08/24.
//

import UIKit

class ScheduleDetailsModalView: UIView {
    weak var delegate: ScheduleDetailsModalDelegate?
    
    private let startTime: String
    private let endTime: String
    private let color: UIColor?
    private let dayOfTheWeek: String

    
    private lazy var closeButton: UIButton = {
        
        let btn = UIButton()
        
        let img = UIImage(systemName: "chevron.left")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .label
        btn.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        
        btn.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var editButton: UIButton = {
        
        let btn = UIButton()
        
        let img = UIImage(systemName: "square.and.pencil")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .label
        btn.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        
        btn.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
                
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 22)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
     let dayLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var hourDetailView: HourDetailsView = {
        let view = HourDetailsView(starTime: self.startTime, endTime: self.endTime, color: self.color!)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 30
        btn.backgroundColor = .label
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "play.fill")
        imageAttachment.image = img?.withTintColor(.systemBackground)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 19, height: 19)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let startString = NSAttributedString(string: String(localized: "startButton"), attributes: [
                .foregroundColor: UIColor.systemBackground,
                .font: UIFont(name: Fonts.darkModeOnSemiBold, size: 16) ?? UIFont.systemFont(ofSize: 16)
            ])
        
        attributedString.append(startString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(imageString)
        
        btn.setAttributedTitle(attributedString, for: .normal)
        
        btn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    init(startTime: String, endTime: String, color: UIColor?, subjectName: String, dayOfTheWeek: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
        self.dayOfTheWeek = dayOfTheWeek
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
//        self.startButton.backgroundColor = color?.darker(by: 0.6)
        
        self.nameLabel.text = subjectName
        self.nameLabel.textColor = color?.darker(by: 0.6)
        self.dayLabel.textColor = color?.darker(by: 0.6)
        self.hourDetailView.startTime.textColor = color?.darker(by: 0.6)
        self.hourDetailView.endTime.textColor = color
        self.hourDetailView.lineStartTime.tintColor = color?.darker(by: 0.6)
        self.hourDetailView.lineEndTime.tintColor = color?.darker(by: 0.6)
        self.hourDetailView.bracket.tintColor = color?.darker(by: 0.6)
        
        self.setDayLabel()
        self.setupUI()
        
        self.layer.cornerRadius = 14
//        self.layer.borderWidth = 1.5
//        self.layer.borderColor = UIColor.label.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDayLabel() {
        let attributedString = NSMutableAttributedString()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(color?.darker(by: 0.6) ?? .label)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 20, height: 20)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let dayString = NSAttributedString(string: self.dayOfTheWeek, attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 18) ?? UIFont.systemFont(ofSize: 16)])
        
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(dayString)

        self.dayLabel.attributedText = attributedString
    }
    
    @objc private func didTapCloseButton() {
        self.delegate?.dismiss()
    }
    
    @objc private func didTapEditButton(){
        self.delegate?.editButtonTapped()
    }
    
    @objc private func didTapStartButton(){
        self.delegate?.startButtonTapped()
    }
}

extension ScheduleDetailsModalView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(editButton)
        addSubview(nameLabel)
        addSubview(dayLabel)
        addSubview(hourDetailView)
        addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            editButton.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            nameLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding / 1.5 ),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding * 1.5),
            
            hourDetailView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding / 1.5 ),
            hourDetailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hourDetailView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 120/385),
            hourDetailView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/100),
            
            startButton.topAnchor.constraint(equalTo: hourDetailView.bottomAnchor, constant: padding * 1.5),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 70/385),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 90/100),
        ])
    }
}
