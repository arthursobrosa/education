//
//  FocusSubjectTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusSubjectTableViewCell: UITableViewCell {
    static let identifier = "focusSubjectCell"
    
    weak var delegate: FocusImediateDelegate?
    
    var indexPath: IndexPath?
    
    var subject: Subject? {
        didSet {
            if let subject {
                self.subjectButton.setTitle(subject.unwrappedName, for: .normal)
                return
            }
            
            self.subjectButton.setTitle(String(localized: "none"), for: .normal)
        }
    }
    
    var color: UIColor? {
        didSet {
            self.subjectButton.setTitleColor(color, for: .normal)
            self.subjectButton.backgroundColor = .white
            self.backgroundColor = color
        }
    }
    
    private lazy var subjectButton: UIButton = {
        let bttn = UIButton()
        bttn.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        bttn.titleLabel?.textAlignment = .center
        bttn.layer.cornerRadius = 26
        
        bttn.addTarget(self, action: #selector(subjectButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
        return bttn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func subjectButtonTapped() {
        self.delegate?.subjectButtonTapped(indexPath: self.indexPath)
    }
}

extension FocusSubjectTableViewCell: ViewCodeProtocol {
    func setupUI() {
        self.contentView.addSubview(subjectButton)
        
        let padding = 24.0
        
        NSLayoutConstraint.activate([
            subjectButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding / 4),
            subjectButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding / 4),
            subjectButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding),
            subjectButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -padding)
        ])
    }
}
