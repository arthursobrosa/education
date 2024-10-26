//
//  SettingsTableViewCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 03/09/24.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "settingsCell"

    private let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1.5

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.tintColor = .systemText80

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let cardTextLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .systemText80
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let customAccessoryView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        updateCardViewColor(traitCollection)

        selectionStyle = .none

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, _: UITraitCollection) in

            self.updateCardViewColor(self.traitCollection)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withText text: String, withImage image: UIImage) {
        cardImageView.image = image.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
        cardTextLabel.text = text
    }

    func setAccessoryView(_ accessoryView: UIView?) {
        guard let accessoryView else { return }

        accessoryView.translatesAutoresizingMaskIntoConstraints = false

        customAccessoryView.addSubview(accessoryView)

        NSLayoutConstraint.activate([
            accessoryView.trailingAnchor.constraint(equalTo: customAccessoryView.trailingAnchor),
            accessoryView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        for subview in customAccessoryView.subviews {
            subview.removeFromSuperview()
        }
    }

    private func updateCardViewColor(_: UITraitCollection) {
        cardView.layer.borderColor = UIColor(named: "button-normal")?.cgColor
    }
}

extension SettingsTableViewCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(cardImageView)
        cardView.addSubview(cardTextLabel)
        cardView.addSubview(customAccessoryView)

        let padding = 5.5

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            cardImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 17),

            cardTextLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardTextLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: 10),

            customAccessoryView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -17),
            customAccessoryView.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3),
            customAccessoryView.heightAnchor.constraint(equalTo: cardView.heightAnchor),
            customAccessoryView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
        ])
    }
}
