//
//  CustomDatePickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 05/08/24.
//

import UIKit

class CustomDatePickerView: UIView {
    let hoursPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 0
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private let hoursLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 50)
        label.text = "h"
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0.8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let minutesPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.tag = 1
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private let minutesLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 50)
        label.text = "min"
        label.textColor = .white
        label.textAlignment = .center
        label.alpha = 0.8
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in self.hoursPicker.subviews {
            subview.backgroundColor = .clear
        }
        
        for subview in self.minutesPicker.subviews {
            subview.backgroundColor = .clear
        }
    }
}

private extension CustomDatePickerView {
    func setupUI() {
        self.addSubview(hoursPicker)
        self.addSubview(hoursLabel)
        self.addSubview(minutesPicker)
        self.addSubview(minutesLabel)
        
        let padding = 10.0
        
        NSLayoutConstraint.activate([
            hoursPicker.topAnchor.constraint(equalTo: self.topAnchor),
            hoursPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (80/250)),
            hoursPicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hoursPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            hoursLabel.leadingAnchor.constraint(equalTo: hoursPicker.trailingAnchor, constant: -padding),
            hoursLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            minutesPicker.topAnchor.constraint(equalTo: hoursPicker.topAnchor),
            minutesPicker.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (80/250)),
            minutesPicker.leadingAnchor.constraint(equalTo: hoursLabel.trailingAnchor, constant: padding),
            minutesPicker.trailingAnchor.constraint(equalTo: minutesLabel.leadingAnchor, constant: padding),
            minutesPicker.bottomAnchor.constraint(equalTo: hoursPicker.bottomAnchor),
            
            minutesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            minutesLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

#Preview {
    CustomDatePickerView()
}
