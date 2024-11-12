//
//  SubjectDetailsView.swift
//  Education
//
//  Created by Eduardo Dalencon on 05/11/24.
//

import UIKit

class EmptySubjectDetailsView: UIView {
    let emptyViewLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "emptySubjectDetails")
        label.textColor = UIColor.systemText40
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = -1
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubview(emptyViewLabel)
        
        NSLayoutConstraint.activate([
            emptyViewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
            emptyViewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
            emptyViewLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -36),
        ])
    }
}
