//
//  CustomDateButton.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class CustomDateButton: UIView {
    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            
            self.dateLabelBack.backgroundColor = color
        }
    }
    
    private var hours = Int()
    private var minutes = Int()
    
    private let dateLabelBack: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        var hoursText = "\(self.hours)"
        var minutesText = "\(self.minutes)"
        
        if self.hours < 10 {
            hoursText = "0" + "\(self.hours)"
        }
        
        if self.minutes < 10 {
            minutesText = "0" + "\(self.minutes)"
        }
        
        label.text = "\(hoursText)h  \(minutesText)min"
        label.textAlignment = .center
        label.textColor = .white
        
        label.isUserInteractionEnabled = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        let dateComponents = DateComponents(
            hour: 0,
            minute: 0
        )
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        
        picker.date = date!
        picker.datePickerMode = .time
        picker.layer.zPosition = 0
        picker.addTarget(self, action: #selector(didTapPicker(_:)), for: .valueChanged)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    init(font: UIFont) {
        super.init(frame: .zero)
        
        self.dateLabel.font = font
        
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.dateLabelBack.layer.cornerRadius = self.dateLabelBack.bounds.height / 4
        
        let dateWidth = self.datePicker.bounds.width
        let backWidth = self.dateLabelBack.bounds.width
        let scaleX = backWidth / dateWidth
        
        let dateHeight = self.datePicker.bounds.height
        let backHeight = self.dateLabelBack.bounds.height
        let scaleY = backHeight / dateHeight
        
        self.datePicker.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    @objc private func didTapPicker(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: sender.date)
        
        guard let hour = dateComponents.hour,
              let minute = dateComponents.minute else { return }
        
        var hoursText = "\(hour)"
        var minutesText = "\(minute)"
        
        if hour < 10 {
            hoursText = "0" + "\(hour)"
        }
        
        if minute < 10 {
            minutesText = "0" + "\(minute)"
        }
        
        self.dateLabel.text = "\(hoursText)h \(minutesText)min"
    }
}

extension CustomDateButton: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(dateLabelBack)
        dateLabelBack.addSubview(dateLabel)
        self.addSubview(datePicker)
        
        let padding = 15.0
        
        NSLayoutConstraint.activate([
            dateLabelBack.widthAnchor.constraint(equalTo: self.widthAnchor),
            dateLabelBack.heightAnchor.constraint(equalTo: self.heightAnchor),
            dateLabelBack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabelBack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateLabelBack.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: dateLabelBack.trailingAnchor, constant: -padding),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            datePicker.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
