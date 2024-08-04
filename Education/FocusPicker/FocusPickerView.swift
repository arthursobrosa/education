//
//  FocusPickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerView: UIView {
    weak var delegate: FocusPickerDelegate?
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = UIColor(named: "FocusSelectionColor")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var startButton: ButtonComponent = {
        let bttn = ButtonComponent(title: "Começar")
        bttn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        return bttn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "FocusSelectionColor")
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func startButtonTapped() {
        
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        self.delegate?.setDate(sender.date)
    }
}

extension FocusPickerView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(datePicker)
        self.addSubview(settingsTableView)
        self.addSubview(startButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            settingsTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: padding * 2),
            settingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            startButton.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: padding),
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            startButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: 0.16)
        ])
    }
}
