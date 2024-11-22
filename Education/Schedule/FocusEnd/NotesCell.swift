//
//  NotesCell.swift
//  Education
//
//  Created by Arthur Sobrosa on 15/10/24.
//

import UIKit

class NotesCell: UITableViewCell {
    // MARK: - Identifier

    static let identifier = "notesCell"
    
    // MARK: - Delegate
    
    weak var delegate: FocusEndDelegate?

    // MARK: - Properties

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

    private lazy var textView: UIView = {
        let textView = UITextView()
        textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        textView.textColor = .label
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "notesPlaceholder")
        label.font = UIFont(name: Fonts.darkModeOnItalic, size: 16)
        label.textColor = .label.withAlphaComponent(0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
}

// MARK: - UI Setup

extension NotesCell: ViewCodeProtocol {
    func setupUI() {
        contentView.addSubview(strokeView)
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)

        let padding = 10.0

        NSLayoutConstraint.activate([
            strokeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            strokeView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 50 / 56),
            strokeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            strokeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            textView.topAnchor.constraint(equalTo: strokeView.topAnchor, constant: padding),
            textView.bottomAnchor.constraint(equalTo: strokeView.bottomAnchor, constant: -padding),
            textView.leadingAnchor.constraint(equalTo: strokeView.leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: strokeView.trailingAnchor, constant: -padding),

            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: padding / 2),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
        ])
    }
}

// MARK: - Text View Delegate

extension NotesCell: UITextViewDelegate {
    func textViewDidBeginEditing(_: UITextView) {
        placeholderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        
        delegate?.updateNotes(with: text)
        
        placeholderLabel.isHidden = !text.isEmpty
    }
}
