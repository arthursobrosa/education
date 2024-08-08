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
        
        date.translatesAutoresizingMaskIntoConstraints = false
        
        return date
    }()
    
    private lazy var rightQuestionsTextField: UITextField = {
        let rightQuestions = UITextField()
        rightQuestions.placeholder = String(localized: "rightQuestions")
        rightQuestions.keyboardType = .numberPad
        
        let toolbar = self.createToolbar(withTag: 0)
        rightQuestions.inputAccessoryView = toolbar
        
        rightQuestions.translatesAutoresizingMaskIntoConstraints = false
        
        return rightQuestions
    }()
    
    private lazy var totalQuestionsTextField: UITextField = {
        let totalQuestions = UITextField()
        totalQuestions.placeholder = String(localized: "totalQuestions")
        totalQuestions.keyboardType = .numberPad
        
        let toolbar = self.createToolbar(withTag: 1)
        totalQuestions.inputAccessoryView = toolbar
        
        totalQuestions.translatesAutoresizingMaskIntoConstraints = false
        
        return totalQuestions
    }()
    
    private lazy var addTestButton: UIButton = {
        let bttn = UIButton(type: .system)
        bttn.setTitle(String(localized: "addTest"), for: .normal)
        bttn.setTitleColor(.label, for: .normal)
        bttn.backgroundColor = .systemGray
        bttn.layer.cornerRadius = 14
        bttn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        bttn.addTarget(self, action: #selector(addTestButtonTapped), for: .touchUpInside)
        
        bttn.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.addSubview(rightQuestionsTextField)
        self.addSubview(totalQuestionsTextField)
        self.addSubview(addTestButton)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
            rightQuestionsTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            rightQuestionsTextField.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            rightQuestionsTextField.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            
            totalQuestionsTextField.topAnchor.constraint(equalTo: rightQuestionsTextField.bottomAnchor, constant: padding),
            totalQuestionsTextField.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            totalQuestionsTextField.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            
            addTestButton.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            addTestButton.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            addTestButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
