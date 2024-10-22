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
        
        let img = UIImage(systemName: "chevron.down")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = UIColor(named: "system-text")
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
        btn.imageView?.tintColor = UIColor(named: "system-text")
        btn.setPreferredSymbolConfiguration(.init(pointSize: 18), forImageIn: .normal)
        
        btn.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 21)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let dayLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var hourDetailView: HourDetailsView = {
        let view = HourDetailsView(starTime: self.startTime, endTime: self.endTime, color: self.color!)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        let attributedText = NSMutableAttributedString(string: String(localized: "startButton"))
        
        let symbolAttachment = NSTextAttachment()
        let symbolImage = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        symbolAttachment.image = symbolImage
        symbolAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)

        let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)

        attributedText.append(NSAttributedString(string: "   "))
        attributedText.append(symbolAttributedString)
        
        let bttn = ButtonComponent(attrString: attributedText,textColor: UIColor(named: "system-modal-bg") ,cornerRadius: 28)
        
        bttn.tintColor = UIColor(named: "system-text")
        
        bttn.backgroundColor = UIColor(named: "button-selected")
        
        bttn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    init(startTime: String, endTime: String, color: UIColor?, subjectName: String, dayOfTheWeek: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
        self.dayOfTheWeek = dayOfTheWeek
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        
        self.nameLabel.text = subjectName
        self.nameLabel.textColor = UIColor(named: "system-text")
        
        self.setDayLabel()
        self.setupUI()
        
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDayLabel() {
        let attributedString = NSMutableAttributedString()
        
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(UIColor(named: "system-text-50")!)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 20, height: 20)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let dayString = NSAttributedString(string: self.dayOfTheWeek, attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 15) ?? UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor(named: "system-text-50") as Any, .baselineOffset : 2])
        
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(dayString)
        
        self.dayLabel.attributedText = attributedString
    }
    
    @objc private func didTapCloseButton() {
        self.delegate?.dismiss()
    }
    
    @objc private func didTapEditButton() {
        self.delegate?.editButtonTapped()
    }
    
    @objc private func didTapStartButton() {
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
            closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            editButton.topAnchor.constraint(equalTo: closeButton.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            
            hourDetailView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 334/366),
            hourDetailView.heightAnchor.constraint(equalTo: hourDetailView.widthAnchor, multiplier: 102/334),
            hourDetailView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 17),
            hourDetailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: hourDetailView.bottomAnchor, constant: padding * 2.2),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 55/327),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 334/366),
        ])
    }
}
