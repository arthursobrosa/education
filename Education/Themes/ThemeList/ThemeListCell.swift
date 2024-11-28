//
//  ThemeListCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 06/09/24.
//

import UIKit

class ThemeListCell: UITableViewCell {
    // MARK: - ID
    
    static let identifier = "themeListCell"
    
    // MARK: - Properties
    
    var titleName: String? {
        didSet {
            guard let titleName else { return }
            
            titleLabel.text = titleName
        }
    }
    
    var dateName: String? {
        didSet {
            if let dateName {
                dateLabel.text = dateName
                dateLabel.isHidden = false
                titleCenterYConstraint?.isActive = false
                titleTopConstraint?.isActive = true
                layoutIfNeeded()
                return
            }
            
            dateLabel.isHidden = true
            titleCenterYConstraint?.isActive = true
            titleTopConstraint?.isActive = false
            layoutIfNeeded()
        }
    }

    // MARK: - UI Properties
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            view.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleCenterYConstraint: NSLayoutConstraint?
    private var titleTopConstraint: NSLayoutConstraint?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        label.textColor = UIColor.systemText80
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)
        label.textColor = UIColor.systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemText80
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()

        for subview in cardView.subviews {
            subview.removeFromSuperview()
        }
    }
}

// MARK: - UI Setup

extension ThemeListCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(cardView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: 14),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            chevronImageView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 20 / 366),
            chevronImageView.heightAnchor.constraint(equalTo: chevronImageView.heightAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
        ])
        
        titleCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 11)
    }
}
