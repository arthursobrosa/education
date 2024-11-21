//
//  FocusSubjectDetailsView.swift
//  Education
//
//  Created by Leandro Silva on 06/11/24.
//

import Foundation
import UIKit

class FocusSubjectDetailsView: UIView {
    
    weak var delegate: FocusSubjectDetailsDelegate?
    
    // MARK: - Properties
    
    private lazy var chevronButton: UIButton = {
        let chevronButton = UIButton()
        chevronButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        chevronButton.tintColor = .systemText50
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        chevronButton.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapChevronButton), for: .touchUpInside)
        return chevronButton
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle(String(localized: "cancel"), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        cancelButton.setTitleColor(UIColor.systemText50, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.isHidden = true
        cancelButton.alpha = 0
        cancelButton.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapCancelButton), for: .touchUpInside)
        
        return cancelButton
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
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
    
    let notesTitle: UILabel = {
        let label = UILabel()
        label.text = String(localized: "notes")
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
        label.textColor = .systemText50
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var editCommentImage: UIButton = {
        let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .systemText50
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.isHidden = false
        editButton.alpha = 1
        editButton.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapEditButton), for: .touchUpInside)
        return editButton
    }()
    
    let notesView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 0.7
        textView.layer.borderColor = UIColor.buttonNormal.cgColor
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 17, bottom: 12, right: 17)
        textView.isScrollEnabled = true
        textView.backgroundColor = .systemBackground
        textView.isEditable = false
        textView.textColor = .systemText
        textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var saveButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapSaveButton), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var discardButton: ButtonComponent = {
        let color: UIColor = UIColor(named: "FocusSettingsColor") ?? UIColor.red
        let attachmentImage = UIImage(systemName: "trash")?.applyingSymbolConfiguration(.init(pointSize: 17))?.withTintColor(color)
        let attachment = NSTextAttachment(image: attachmentImage ?? UIImage())
        let attachmentString = NSAttributedString(attachment: attachment)
        let title = String(localized: "discard") + String(repeating: " ", count: 4)
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
        button.addTarget(delegate, action: #selector(FocusSubjectDetailsDelegate.didTapDiscardButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods hide and show
    
    @objc 
    private func editButtonTapped() {
        delegate?.didTapEditButton()
    }
    
    @objc 
    private func cancelButtonTapped() {
        delegate?.didTapCancelButton()
    }
    
    func showCancelButton() {
        cancelButton.isHidden = false
        cancelButton.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
        }
    }
    
    func hideCancelButton() {
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0
        } completion: { _ in
            self.cancelButton.isHidden = true
        }
    }
    
    func showEditButton() {
        editCommentImage.isHidden = false
        editCommentImage.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.editCommentImage.alpha = 1
        }
    }
    
    func hideEditButton() {
        UIView.animate(withDuration: 0.3) {
            self.editCommentImage.alpha = 0
        } completion: { _ in
            self.editCommentImage.isHidden = true
        }
    }
    
    func showSaveButton() {
        saveButton.isHidden = false
        saveButton.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 1
        }
    }
    
    func hideSabeButton() {
        UIView.animate(withDuration: 0.3) {
            self.saveButton.alpha = 0
        } completion: { _ in
            self.saveButton.isHidden = true
        }
    }
}

extension FocusSubjectDetailsView: ViewCodeProtocol {
    func setupUI() {
        addSubview(chevronButton)
        addSubview(cancelButton)
        
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(notesTitle)
        addSubview(editCommentImage)
        addSubview(notesView)
        
        addSubview(saveButton)
        addSubview(discardButton)

        NSLayoutConstraint.activate([
            chevronButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            chevronButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
            
            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -18),
            
            titleLabel.topAnchor.constraint(equalTo: chevronButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 23),

            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 92 / 344),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            
            notesTitle.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            notesTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            
            editCommentImage.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            editCommentImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            
            notesView.topAnchor.constraint(equalTo: notesTitle.bottomAnchor, constant: 5),
            notesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            notesView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            notesView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 334 / 390),
            saveButton.heightAnchor.constraint(equalTo: saveButton.widthAnchor, multiplier: 55 / 334),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: discardButton.topAnchor, constant: -11),

            discardButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor),
            discardButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            discardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            discardButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
        ])
    }
}
