//
//  FocusPickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerView: UIView {
    weak var delegate: FocusPickerDelegate?
    
    private let timerCase: TimerCase
    
    private lazy var backButton: UIButton = {
        let bttn = UIButton()
        bttn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        bttn.tintColor = .label
        
        bttn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    lazy var dateView: DateView = {
        let view = DateView(timerCase: self.timerCase)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = self.backgroundColor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var startButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "start"))
        
        bttn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        bttn.setTitle(String(localized: "cancel"), for: .normal)
        bttn.setTitleColor(.secondaryLabel, for: .normal)
        
        bttn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    lazy var titleTexto: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    init(timerCase: TimerCase) {
        self.timerCase = timerCase
        
        super.init(frame: .zero)
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 12
        
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
        self.addSubview(titleTexto)
        self.addSubview(dateView)
        self.addSubview(settingsTableView)
        self.addSubview(startButton)
        self.addSubview(cancelButton)
        
        var widthMultiplier = Double()
        var heightMultiplier = Double()
        
        switch self.timerCase {
            case .timer:
                widthMultiplier = 170 / 359
                heightMultiplier = 180 / 170
            case .pomodoro:
                widthMultiplier = 302 / 359
                heightMultiplier = 293 / 302
            default:
                break
        }
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            titleTexto.topAnchor.constraint(equalTo: backButton.topAnchor),
            titleTexto.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            titleTexto.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            dateView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthMultiplier),
            dateView.heightAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: heightMultiplier),
            dateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: padding),
            
            settingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalTo: settingsTableView.widthAnchor, multiplier: (161/366)),
            settingsTableView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            settingsTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: padding),
            
            startButton.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: padding),
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (334/366)),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: (55/330)),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: padding * 0.5),
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
