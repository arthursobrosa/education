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

    
    private lazy var closeButton: UIButton = {
        
        let btn = UIButton()
        
        let img = UIImage(systemName: "xmark")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .white
        btn.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        
        btn.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private lazy var editButton: UIButton = {
        
        let btn = UIButton()
        
        let img = UIImage(systemName: "square.and.pencil")
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = .white
        btn.setPreferredSymbolConfiguration(.init(pointSize: 24), forImageIn: .normal)
        
        btn.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
                
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let nameLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 32)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private let dayLabel: UILabel = {
        
        let lbl = UILabel()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        
        lbl.font = UIFont.systemFont(ofSize: 22)
        imageAttachment.image = UIImage(systemName: "clock")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 22, height: 22)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: "Segunda-feira"))

        lbl.attributedText = attributedString
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    private lazy var hourDetailView: HourDetailsView = {
        
        let view = HourDetailsView(starTime: self.startTime, endTime: self.endTime)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var startButton: UIButton = {
        
        let btn = UIButton()
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let img = UIImage(systemName: "play.fill")
        
        imageAttachment.image = img?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3.0, width: 19, height: 19)
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(NSAttributedString(string: "Iniciar agora"))
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(imageString)
        

        btn.setAttributedTitle(attributedString, for: .normal)
        btn.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .black.withAlphaComponent(0.25)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()

    init(startTime: String, endTime: String, color: UIColor?, subjectName: String, dayOfTheWeek: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.color = color
        
        super.init(frame: .zero)
        
        self.backgroundColor = color
        self.startButton.backgroundColor = color?.darker(by: 0.6)
        
        self.nameLabel.text = subjectName
        
        self.dayLabel.text = dayOfTheWeek
        
        self.setupUI()
        
        self.layer.cornerRadius = 14
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapCloseButton(){
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
            
            nameLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: padding),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            hourDetailView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: padding),
            hourDetailView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hourDetailView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 102/385),
            hourDetailView.widthAnchor.constraint(equalTo: hourDetailView.heightAnchor, multiplier: 321/102),
            
            startButton.topAnchor.constraint(equalTo: hourDetailView.bottomAnchor, constant: padding * 2),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            startButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 52/385),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 321/385),
        ])
    }
}

#Preview {
    ScheduleDetailsModalViewController(viewModel: ScheduleDetailsModalViewModel(schedule: Schedule()))
}
