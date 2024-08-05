//
//  FocusPickerView.swift
//  Education
//
//  Created by Arthur Sobrosa on 02/08/24.
//

import UIKit

class FocusPickerView: UIView {
    weak var delegate: FocusPickerDelegate?
    
    lazy var dateView: DateView = {
        let view = DateView()
        
        view.pomodoroWorkDatePicker.color = self.backgroundColor?.getDarkerColor()
        view.pomodoroRestDatePicker.color = self.backgroundColor?.getSecondaryColor()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = UIColor(named: "FocusSelectionColor")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var startButton: ActionButton = {
        let titleColor = self.backgroundColor?.getDarkerColor()
        let bttn = ActionButton(title: "Começar", titleColor: titleColor)
        
        bttn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.setTitle("Cancel", for: .normal)
        bttn.setTitleColor(self.backgroundColor?.getDarkerColor(), for: .normal)
        
        bttn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.delegate?.startButtonTapped()
    }
    
    @objc private func cancelButtonTapped() {
        self.delegate?.cancelButtonTapped()
    }
}

extension FocusPickerView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(dateView)
        self.addSubview(settingsTableView)
        self.addSubview(startButton)
        self.addSubview(cancelButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            dateView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            dateView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (323/359)),
            dateView.heightAnchor.constraint(equalTo: dateView.widthAnchor, multiplier: (255/323)),
            
            settingsTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: padding * 3.5),
            settingsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -padding),
            
            startButton.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(padding * 2)),
            startButton.heightAnchor.constraint(equalTo: startButton.widthAnchor, multiplier: (70/330)),
            startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: padding),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            cancelButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}
