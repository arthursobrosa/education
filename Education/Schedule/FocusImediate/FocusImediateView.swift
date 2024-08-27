//
//  FocusImediateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateView: UIView {
    weak var delegate: FocusImediateDelegate?
    
    private lazy var cancelButton: UIButton = {
        let bttn = UIButton(configuration: .plain())
        bttn.setTitle(String(localized: "cancel"), for: .normal)
        bttn.setTitleColor(self.backgroundColor?.darker(by: 0.6), for: .normal)
        
        bttn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        label.text = String(localized: "subjectAttributionQuestion")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var subjectsTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = self.backgroundColor
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    init(color: UIColor?) {
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
    
    @objc private func cancelButtonTapped() {
        self.delegate?.cancelButtonTapped()
    }
}

extension FocusImediateView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(cancelButton)
        self.addSubview(topLabel)
        self.addSubview(subjectsTableView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: self.topAnchor, constant: padding / 2),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding / 2),
            
            topLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: padding),
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (296/359)),
            
            subjectsTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: padding),
            subjectsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            subjectsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subjectsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
