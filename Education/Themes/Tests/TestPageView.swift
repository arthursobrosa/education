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
    
    private lazy var deleteButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "deleteTest"), textColor: UIColor(named: "FocusSettingsColor"), cornerRadius: 28)
        bttn.backgroundColor = .clear
        bttn.layer.borderColor = UIColor(named: "destructiveColor")?.cgColor
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
        
        self.backgroundColor = .systemBackground
        self.setupKeyboardObservers()
        
        self.setupUI()
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.updateViewColor(self.traitCollection)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    @objc private func didTapDeleteButton() {
        self.delegate?.didTapDeleteButton()
    }
    
    @objc private func didTapSaveButton() {
        self.delegate?.didTapSaveButton()
    }
    
    func hideDeleteButton() {
        self.deleteButton.isHidden = true
    }
    
    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolBar.items = [flexSpace, doneButton]
        
        return toolBar
    }
    
    private func updateViewColor(_ traitCollection: UITraitCollection) {
        textView.layer.borderColor = UIColor(named: "button-normal")?.cgColor
    }
    
    @objc private func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var visibleRect = self.frame
        visibleRect.size.height -= keyboardHeight
        let textViewFrameInSuperview = textView.convert(textView.bounds, to: self)
        if !visibleRect.contains(textViewFrameInSuperview.origin) {
            scrollView.scrollRectToVisible(textViewFrameInSuperview, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

// MARK: - UI Setup
extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(tableView)
        self.addSubview(textView)
        self.addSubview(deleteButton)
        self.addSubview(saveButton)
        
        textView.inputAccessoryView = createToolBar()
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            textView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -60),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            
            deleteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            deleteButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 55/770),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -padding),
            
            saveButton.leadingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: deleteButton.heightAnchor),
        ])
        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        saveButtonBottomConstraint.isActive = true
    }
}
