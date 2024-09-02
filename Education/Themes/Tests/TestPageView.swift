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
    let datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.preferredDatePickerStyle = .inline
        date.datePickerMode = .date
        date.maximumDate = Date()
        date.tintColor = .label
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    private lazy var rightQuestionsContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = String(localized: "rightQuestions")
        titleLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        titleLabel.textColor = UIColor.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(rightQuestionsTextField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            rightQuestionsTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            rightQuestionsTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rightQuestionsTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rightQuestionsTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            rightQuestionsTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        return containerView
    }()
    
    private lazy var rightQuestionsTextField: UITextField = {
        let rightQuestions = UITextField()
        rightQuestions.keyboardType = .numberPad
        rightQuestions.backgroundColor = UIColor.secondarySystemBackground
        rightQuestions.layer.cornerRadius = 8
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: rightQuestions.frame.height))
        rightQuestions.leftView = paddingView
        rightQuestions.leftViewMode = .always
        
        let toolbar = self.createToolbar(withTag: 0)
        rightQuestions.inputAccessoryView = toolbar
        
        rightQuestions.translatesAutoresizingMaskIntoConstraints = false
        
        return rightQuestions
    }()
    
    private lazy var totalQuestionsContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = String(localized: "totalQuestions")
        titleLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 14)
        titleLabel.textColor = UIColor.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        
        containerView.addSubview(titleLabel)
        containerView.addSubview(totalQuestionsTextField)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            totalQuestionsTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            totalQuestionsTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            totalQuestionsTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            totalQuestionsTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            totalQuestionsTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        return containerView
    }()
    
    private lazy var totalQuestionsTextField: UITextField = {
        let totalQuestions = UITextField()
        totalQuestions.keyboardType = .numberPad
        totalQuestions.backgroundColor = UIColor.secondarySystemBackground
        totalQuestions.layer.cornerRadius = 8
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: totalQuestions.frame.height))
        totalQuestions.leftView = paddingView
        totalQuestions.leftViewMode = .always
        
        let toolbar = self.createToolbar(withTag: 1)
        totalQuestions.inputAccessoryView = toolbar
        
        totalQuestions.translatesAutoresizingMaskIntoConstraints = false
        
        return totalQuestions
    }()
    
    private lazy var addTestButton: ButtonComponent = {
        let bttn = ButtonComponent(title: String(localized: "addTest"))
        
        bttn.addTarget(self, action: #selector(addTestButtonTapped), for: .touchUpInside)
        
        return bttn
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Methods
    @objc private func addTestButtonTapped() {
        let totalQuestions = Int(self.totalQuestionsTextField.text ?? "0") ?? 0
        let rightQuestions = Int(self.rightQuestionsTextField.text ?? "0") ?? 0
        let date = self.datePicker.date
        
        self.delegate?.addTestTapped(totalQuestions: totalQuestions, rightQuestions: rightQuestions, date: date)
    }
    
    @objc func doneKeyboardButtonTapped(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            self.rightQuestionsTextField.resignFirstResponder()
        case 1:
            self.totalQuestionsTextField.resignFirstResponder()
        default:
            break
        }
    }
}

// MARK: - UI Setup
extension TestPageView: ViewCodeProtocol {
    func setupUI() {
        self.addSubview(datePicker)
        self.addSubview(rightQuestionsContainerView)
        self.addSubview(totalQuestionsContainerView)
        self.addSubview(addTestButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            rightQuestionsContainerView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: padding),
            rightQuestionsContainerView.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            rightQuestionsContainerView.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            
            totalQuestionsContainerView.topAnchor.constraint(equalTo: rightQuestionsContainerView.bottomAnchor, constant: padding),
            totalQuestionsContainerView.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            totalQuestionsContainerView.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            
            addTestButton.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            addTestButton.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            addTestButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            addTestButton.heightAnchor.constraint(equalTo: addTestButton.widthAnchor, multiplier: 0.16)
        ])
    }
    
    private func createToolbar(withTag tag: Int) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneKeyboardButtonTapped(_:)))
        doneButton.tag = tag
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        return toolbar
    }
}
