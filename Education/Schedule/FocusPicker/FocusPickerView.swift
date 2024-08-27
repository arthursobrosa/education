//
//  FocusPickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerView: UIView {
    weak var delegate: FocusPickerDelegate? {
        didSet {
            dateView.delegate = delegate
        }
    }
    
    private let timerCase: TimerCase?
    
    private lazy var backButton: UIButton = {
        let bttn = UIButton()
        bttn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        bttn.tintColor = .white
        
        bttn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    lazy var dateView: DateView = {
        let view = DateView(timerCase: self.timerCase)
        view.pomodoroWorkDatePicker.color = self.backgroundColor?.darker(by: 0.6)
        view.pomodoroRestDatePicker.color = self.backgroundColor?.darker(by: 0.8)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = self.backgroundColor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var startButton: ActionButton = {
        let titleColor = self.backgroundColor?.darker(by: 0.6)
        let bttn = ActionButton(title: String(localized: "start"), titleColor: titleColor)
        
        bttn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        bttn.setTitle(String(localized: "cancel"), for: .normal)
        bttn.setTitleColor(self.backgroundColor?.darker(by: 0.6), for: .normal)
        
        bttn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    init(color: UIColor?, timerCase: TimerCase?) {
        self.timerCase = timerCase
        
        super.init(frame: .zero)
        
        self.backgroundColor = color
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.label.cgColor
        self.layer.borderWidth = 1
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonTapped() {
        self.delegate?.dismiss()
    }
    
    @objc private func startButtonTapped() {
        self.delegate?.startButtonTapped()
    }
    
    @objc private func cancelButtonTapped() {
        self.delegate?.dismissAll()
    }
}

extension FocusPickerView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(backButton)
        self.addSubview(dateView)
        self.addSubview(settingsTableView)
        self.addSubview(startButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            dateView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (310/359)),
            dateView.heightAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: (167/310)),
            dateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: padding * 3.5),
            
            settingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalTo: settingsTableView.widthAnchor, multiplier: (144/359)),
            settingsTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            settingsTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: padding),
            
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (330/359)),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: (70/330)),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: padding * 0.7),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
