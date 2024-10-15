//
//  FocusEndView.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class FocusEndView: UIView {
    // MARK: - Delegate to bind with VC
    weak var delegate: FocusEndDelegate?
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "finishTimerAlertTitle")
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderColor = UIColor.red.cgColor
        tableView.layer.borderWidth = 2
        return tableView
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        button.addTarget(delegate, action: #selector(FocusEndDelegate.didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var discardButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "discard"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(FocusEndDelegate.didTapDiscardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup
extension FocusEndView: ViewCodeProtocol {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(activityTableView)
        addSubview(saveButton)
        addSubview(discardButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            activityTableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 344 / 390),
            activityTableView.heightAnchor.constraint(equalTo: activityTableView.widthAnchor, multiplier: 528 / 344),
            activityTableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 390),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 55 / 334),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: activityTableView.bottomAnchor, constant: 33),
            
            discardButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            discardButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            discardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            discardButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 11),
        ])
    }
}
