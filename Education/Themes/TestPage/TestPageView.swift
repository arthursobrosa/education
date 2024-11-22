//
//  TestPageView.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import UIKit

class TestPageView: UIView {
    // MARK: - Delegate

    weak var delegate: TestDelegate?

    // MARK: - UI Components
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(configuration: .plain())
        let title = String(localized: "cancel")
        let color: UIColor = .systemText50
        let font: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font,
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(delegate, action: #selector(TestDelegate.didTapCancelButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: Fonts.darkModeOnSemiBold, size: 14)
        label.textColor = .systemText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let tableView: BorderedTableView = {
        let tableView = BorderedTableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableHeightConstraint: NSLayoutConstraint?

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.layer.borderWidth = 0.7
        textView.layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            textView.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        textView.layer.cornerRadius = 18
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var deleteButton: ButtonComponent = {
        let button = ButtonComponent(title: String(localized: "deleteTest"), textColor: .focusColorRed, cornerRadius: 28)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.focusColorRed.cgColor
        button.layer.borderWidth = 2
        button.addTarget(delegate, action: #selector(TestDelegate.didTapDeleteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        bttn.addTarget(delegate, action: #selector(TestDelegate.didTapSaveButton), for: .touchUpInside)
        bttn.translatesAutoresizingMaskIntoConstraints = false
        return bttn
    }()
    
    private var saveButtonBottomConstraint: NSLayoutConstraint?
    
    let deleteAlertView: AlertView = {
        let view = AlertView()
        view.isHidden = true
        view.layer.zPosition = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .label.withAlphaComponent(0.1)
        view.alpha = 0
        view.layer.zPosition = 1
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializer
    
    init(title: String, showsDeleteButton: Bool) {
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        setupUI()
        
        titleLabel.text = title
        deleteButton.isHidden = !showsDeleteButton
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTableHeight()
    }

    // MARK: - Methods
    
    func setUpTextView(withComment comment: String) {
        if comment.isEmpty {
            textView.text = String(localized: "testNotesPlaceholder")
            textView.font = UIFont(name: Fonts.darkModeOnItalic, size: 16)
            textView.textColor = .systemText40
        } else {
            textView.text = comment
            textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
            textView.textColor = .systemText
        }
    }
    
    private func updateTableHeight() {
        let tableHeight = tableView.contentSize.height
        tableHeightConstraint?.constant = tableHeight
        layoutIfNeeded()
    }
    
    func changeAlertVisibility(isShowing: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }

            self.deleteAlertView.isHidden = !isShowing
            self.overlayView.alpha = isShowing ? 1 : 0
        }
        
        if isShowing {
            setGestureRecognizer()
        } else {
            gestureRecognizers = nil
        }
        
        for subview in subviews where !(subview is AlertView) {
            subview.isUserInteractionEnabled = !isShowing
        }
    }
    
    private func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func viewWasTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        
        guard !deleteAlertView.frame.contains(tapLocation) else { return }
        
        changeAlertVisibility(isShowing: false)
    }
}

// MARK: - UI Setup

extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        addSubview(cancelButton)
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(textView)
        addSubview(deleteButton)
        addSubview(saveButton)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            titleLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 55 / 770),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -12),

            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
        ])
        
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint?.isActive = true
        
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        saveButtonBottomConstraint?.isActive = true
        
        addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
