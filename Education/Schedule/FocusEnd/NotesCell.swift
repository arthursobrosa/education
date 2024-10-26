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

    // MARK: - Properties

    private let strokeView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textView: UIView = {
        let textView = UITextView()
        textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        textView.textColor = .label
        let toolbar = createToolbar()
        textView.inputAccessoryView = toolbar
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

    // MARK: - Methods

    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneKeyboardButtonTapped(_:)))

        toolbar.setItems([flexSpace, doneButton], animated: false)

        return toolbar
    }

    @objc private func doneKeyboardButtonTapped(_: UIBarButtonItem) {
        textView.resignFirstResponder()
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
            strokeView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            strokeView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -padding),
            strokeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            strokeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

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
        if let text = textView.text,
           !text.isEmpty
        {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
}
