//
//  SubjectListTableViewCell.swift
//  Education
//
//  Created by Leandro Silva on 19/08/24.
//

import UIKit

class SubjectListTableViewCell: UITableViewCell {
    static let identifier = "subjectListTableViewCell"
    
    // MARK: - UI Components
    private let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if self.traitCollection.userInterfaceStyle == .light {
            self.backgroundColor = .systemGray5
        }
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with subject: Subject) {
        subjectLabel.text = subject.name
        colorCircle.backgroundColor = UIColor(named: subject.color ?? "sealBackgroundColor")
    }
}

extension SubjectListTableViewCell: ViewCodeProtocol {
    func setupUI() {
        
        self.contentView.addSubview(colorCircle)
        self.contentView.addSubview(subjectLabel)
        self.contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            colorCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            colorCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircle.widthAnchor.constraint(equalToConstant: 25),
            colorCircle.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            subjectLabel.leadingAnchor.constraint(equalTo: colorCircle.trailingAnchor, constant: 15),
            subjectLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
