//
//  FocusEndSubjectCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 04/11/24.
//

import UIKit

class FocusEndSubjectCell: UITableViewCell {
    // MARK: - Identifier
    
    static let identifier = "focusEndSubjectCell"
    
    // MARK: - Properties
    
    var title: String? {
        didSet {
            guard let title else { return }
            
            titleLabel.text = title
        }
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Properties

    private lazy var strokeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        
        view.layer.borderColor = UIColor.buttonNormal.cgColor
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            view.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.preferredSymbolConfiguration = .init(pointSize: 18)
        imageView.tintColor = UIColor.systemText40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}

// MARK: - UI Setup

extension FocusEndSubjectCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(strokeView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            strokeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            strokeView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 54 / 60),
            strokeView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            strokeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            strokeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: strokeView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: strokeView.leadingAnchor, constant: 17),
            titleLabel.trailingAnchor.constraint(equalTo: strokeView.trailingAnchor, constant: -40),
            
            chevronImageView.centerYAnchor.constraint(equalTo: strokeView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: strokeView.trailingAnchor, constant: -17),
        ])
    }
}
