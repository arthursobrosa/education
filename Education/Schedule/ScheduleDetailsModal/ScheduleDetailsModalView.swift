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
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 21)
        lbl.textAlignment = .center
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
        
        let bttn = ButtonComponent(attrString: attributedText, cornerRadius: 28)
        
        bttn.tintColor = .label
        
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
        
        self.titleLabel.text = subjectName
        self.titleLabel.textColor = color?.darker(by: 0.8)
        
        self.setDayLabel()
        self.setupUI()
        
        self.layer.cornerRadius = 14
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDayLabel() {
        let attributedString = NSMutableAttributedString()
        
        let darkerColor: UIColor = self.color?.darker(by: 0.8) ?? .label
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(darkerColor)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 20, height: 20)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        let dayString = NSAttributedString(string: self.dayOfTheWeek, attributes: [.font : UIFont(name: Fonts.darkModeOnMedium, size: 15) ?? UIFont.systemFont(ofSize: 15), .foregroundColor : darkerColor, .baselineOffset : 2])
        
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
        addSubview(titleLabel)
        addSubview(dayLabel)
        addSubview(hourDetailView)
        addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            editButton.topAnchor.constraint(equalTo: closeButton.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -70),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            
            hourDetailView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
            hourDetailView.heightAnchor.constraint(equalTo: hourDetailView.widthAnchor, multiplier: 102 / 334),
            hourDetailView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 17),
            hourDetailView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            startButton.topAnchor.constraint(equalTo: hourDetailView.bottomAnchor, constant: padding * 2.2),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 55 / 327),
            startButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 366),
        ])
    }
}
