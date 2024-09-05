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
                self.subjectButton.setTitleColor(UIColor(named: subject.unwrappedColor)!, for: .normal)
                self.subjectButton.layer.borderColor = UIColor(named: subject.unwrappedColor)!.cgColor
                return
            }
            
            self.subjectButton.setTitle(String(localized: "none"), for: .normal)
            self.subjectButton.setTitleColor(.label, for: .normal)
            self.subjectButton.layer.borderColor = UIColor.label.cgColor
            
        }
    }
    
    private lazy var subjectButton: UIButton = {
        let bttn = UIButton()
        bttn.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        bttn.titleLabel?.textAlignment = .center
        bttn.layer.cornerRadius = 26
        bttn.backgroundColor = .clear
        bttn.layer.borderWidth = 1
        
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
