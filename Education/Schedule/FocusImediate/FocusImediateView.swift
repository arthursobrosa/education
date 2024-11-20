//
//  FocusImediateView.swift
//  Education
//
//  Created by Arthur Sobrosa on 09/08/24.
//

import UIKit

class FocusImediateView: UIView {
    weak var delegate: FocusImediateDelegate?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12))
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .systemText40
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "imediateActivity")

        return label
    }()

    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .label
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
        table.backgroundColor = backgroundColor
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(color: UIColor?) {
        super.init(frame: .zero)

        backgroundColor = color
        layer.cornerRadius = 24

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc 
    private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
}

extension FocusImediateView: ViewCodeProtocol {
    func setupUI() {
        addSubview(closeButton)
        addSubview(topLabel)
        addSubview(titleLabel)
        addSubview(subjectsTableView)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 27 / 366),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            topLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            topLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            topLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),

            subjectsTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 39),
            subjectsTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            subjectsTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            subjectsTableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
}
