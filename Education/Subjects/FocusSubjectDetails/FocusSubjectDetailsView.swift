//
//  FocusSubjectDetailsView.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import Foundation
import UIKit

class FocusSubjectDetailsView: UIView {
    // MARK: - Delegates to connect with VC
    
    weak var delegate: FocusSubjectDetailsDelegate?
    weak var textViewDelegate: (any UITextViewDelegate)? {
        didSet {
            notesTextView.delegate = textViewDelegate
        }
    }
    
    // MARK: - Properties
    
    private let title: String
    private let notes: String
    
    // MARK: - UI Properties
    
    private lazy var chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .systemText40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapChevronButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(String(localized: "cancel"), for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        button.setTitleColor(UIColor.systemText50, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.alpha = 0
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: Fonts.coconRegular, size: 26)
        label.textColor = .systemText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = .init(top: -22, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let notesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = String(localized: "notes")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notesTextView: UITextView = {
        let textView = UITextView()
        textView.text = notes
        textView.textColor = .systemText
        
        textView.layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            textView.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        textView.font = .init(name: Fonts.darkModeOnRegular, size: 16)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var textViewTopConstraint: NSLayoutConstraint?
    private var textViewLeadingConstraint: NSLayoutConstraint?
    
    private lazy var notesPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.isHidden = !notes.isEmpty
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editCommentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.tintColor = .systemText50
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        button.alpha = 1
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapEditButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapSaveButton), for: .touchUpInside)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteButton: ButtonComponent = {
        let color: UIColor = UIColor(named: "FocusSettingsColor") ?? UIColor.red
        let attachmentImage = UIImage(systemName: "trash")?.applyingSymbolConfiguration(.init(pointSize: 17))?.withTintColor(color)
        let attachment = NSTextAttachment(image: attachmentImage ?? UIImage())
        let attachmentString = NSAttributedString(attachment: attachment)
        let title = String(localized: "erase") + String(repeating: " ", count: 4)
        let titleFont: UIFont = UIFont(name: Fonts.darkModeOnMedium, size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        let attributedString = NSAttributedString(string: title, attributes: [.font: titleFont, .foregroundColor: color])
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(attachmentString)
        mutableAttrString.append(NSAttributedString(string: "  "))
        mutableAttrString.append(attributedString)
        let button = ButtonComponent(title: "", cornerRadius: 28)
        button.setAttributedTitle(mutableAttrString, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 17)
        button.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    
    init(title: String, notes: String) {
        self.title = title
        self.notes = notes
        
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        updateNotesTextViewUI(isEditable: false)
        setupUI()
        setNotesPlaceholder()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func changeButtonsVisibility(isEditing: Bool) {
        changeCancelButtonVisibility(isShowing: isEditing)
        changeEditButtonVisibility(isShowing: !isEditing)
    }
    
    private func changeCancelButtonVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            self.cancelButton.alpha = isShowing ? 1 : 0
        }
    }
    
    private func changeEditButtonVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            self.editCommentButton.alpha = isShowing ? 1 : 0
        }
    }
    
    func changeSaveButtonVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            
            self.saveButton.alpha = isShowing ? 1 : 0
        }
    }
    
    func changeNotesPlaceholderVisibility(isShowing: Bool) {
        notesPlaceholderLabel.isHidden = !isShowing
    }
    
    func changeNotesTextViewState(isEditable: Bool) {
        notesTextView.isEditable = isEditable
        layoutNotesPlaceholder()
        updateNotesTextViewUI(isEditable: isEditable)
        setNotesPlaceholder()
        
        if let notes = notesTextView.text {
            notesPlaceholderLabel.isHidden = !notes.isEmpty
        }
    }
    
    private func updateNotesTextViewUI(isEditable: Bool) {
        if isEditable {
            notesTextView.layer.cornerRadius = 18
            notesTextView.layer.borderWidth = 0.7
            notesTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            notesTextView.isEditable = true
        } else {
            notesTextView.layer.cornerRadius = 0
            notesTextView.layer.borderWidth = 0
            notesTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            notesTextView.isEditable = false
        }
    }
    
    func updateNotesTextViewText(_ text: String) {
        notesTextView.text = text
    }
    
    func setNotesPlaceholder() {
        let isEditable = notesTextView.isEditable
        var text: String
        var textColor: UIColor
        
        if isEditable {
            text = String(localized: "notesPlaceholder")
            textColor = .buttonNormal
        } else {
            text = String(localized: "emptyNotes")
            textColor = .systemText
        }
        
        notesPlaceholderLabel.text = text
        notesPlaceholderLabel.font = .init(name: Fonts.darkModeOnItalic, size: 16)
        notesPlaceholderLabel.textColor = textColor
    }
}

// MARK: - UI Setup

extension FocusSubjectDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(chevronButton)
        addSubview(cancelButton)
        
        addSubview(titleLabel)
        
        addSubview(tableView)
        
        addSubview(notesTitleLabel)
        addSubview(notesTextView)
        
        addSubview(editCommentButton)
        
        addSubview(saveButton)
        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            chevronButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            chevronButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
            
            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -18),
            
            titleLabel.topAnchor.constraint(equalTo: chevronButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 23),

            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 92 / 344),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            
            notesTitleLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            notesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            
            notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            notesTextView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            editCommentButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            editCommentButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            
            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 390),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 55 / 334),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -11),

            deleteButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            deleteButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
        ])
        
        textViewTopConstraint = notesTextView.topAnchor.constraint(equalTo: notesTitleLabel.bottomAnchor)
        textViewTopConstraint?.isActive = true
        
        textViewLeadingConstraint = notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor)
        textViewLeadingConstraint?.isActive = true
        
        layoutNotesPlaceholder()
    }
    
    private func layoutNotesPlaceholder() {
        notesPlaceholderLabel.removeFromSuperview()
        notesTextView.addSubview(notesPlaceholderLabel)
        
        let isEditing = notesTextView.isEditable
        
        if isEditing {
            textViewTopConstraint?.constant = 5
            textViewLeadingConstraint?.constant = 23
        } else {
            textViewTopConstraint?.constant = 2
            textViewLeadingConstraint?.constant = 18
        }
        
        let topPadding: Double = isEditing ? 12 : 0
        let leadingPadding: Double = isEditing ? 12 : 0
        
        NSLayoutConstraint.activate([
            notesPlaceholderLabel.topAnchor.constraint(equalTo: notesTitleLabel.bottomAnchor, constant: topPadding + 5),
            notesPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingPadding + 23),
        ])
    }
}
