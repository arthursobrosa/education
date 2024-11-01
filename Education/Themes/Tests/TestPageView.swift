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

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let tableView: CustomTableView = {
        let table = CustomTableView()

        table.translatesAutoresizingMaskIntoConstraints = false

        return table
    }()

    let textView: UITextView = {
        let textV = UITextView()

        textV.translatesAutoresizingMaskIntoConstraints = false

        textV.layer.borderWidth = 0.7
        textV.layer.borderColor = UIColor.buttonNormal.cgColor
        textV.layer.cornerRadius = 18

        textV.textContainerInset = UIEdgeInsets(top: 12, left: 17, bottom: 12, right: 17)

        textV.isScrollEnabled = true

        textV.backgroundColor = .systemBackground

        return textV
    }()

    lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteTest"), textColor: .focusColorRed, cornerRadius: 28)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor.focusColorRed.cgColor
        bttn.layer.borderWidth = 2

        bttn.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    private lazy var saveButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "save"), cornerRadius: 28)
        bttn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        bttn.translatesAutoresizingMaskIntoConstraints = false

        return bttn
    }()

    // MARK: - Initialization

    var saveButtonBottomConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        //setupKeyboardObservers()

        setupUI()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.updateViewColor(self.traitCollection)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    @objc 
    private func didTapDeleteButton() {
        delegate?.didTapDeleteButton()
    }

    @objc 
    private func didTapSaveButton() {
        delegate?.didTapSaveButton()
    }

    func hideDeleteButton() {
        deleteButton.isHidden = true
    }

//    private func createToolBar() -> UIToolbar {
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
//
//        toolBar.items = [flexSpace]
//
//        return toolBar
//    }

    private func updateViewColor(_: UITraitCollection) {
        textView.layer.borderColor = UIColor(named: "button-normal")?.cgColor
    }

//    @objc 
//    private func dismissKeyboard() {
//        textView.resignFirstResponder()
//    }
//
//    private func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }

//    @objc 
//    private func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//
//        let keyboardHeight = keyboardFrame.height
//
//        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//
//        var visibleRect = frame
//        visibleRect.size.height -= keyboardHeight
//        let textViewFrameInSuperview = textView.convert(textView.bounds, to: self)
//        if !visibleRect.contains(textViewFrameInSuperview.origin) {
//            scrollView.scrollRectToVisible(textViewFrameInSuperview, animated: true)
//        }
//    }
//
//    @objc 
//    private func keyboardWillHide(notification _: NSNotification) {
//        let contentInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInsets
//        scrollView.scrollIndicatorInsets = contentInsets
//    }
}

// MARK: - UI Setup

extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        addSubview(tableView)
        addSubview(textView)
        addSubview(deleteButton)
        addSubview(saveButton)

        //textView.inputAccessoryView = createToolBar()

        let padding = 20.0

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),

            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -60),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),

            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 55 / 770),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding),

            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
        ])
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        saveButtonBottomConstraint.isActive = true
    }
}
