//
//  TestPageView.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class TestPageView: UIView {
    
    // MARK: - UI Components
    lazy var datePicker: UIDatePicker = {
        let date = UIDatePicker()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.preferredDatePickerStyle = .inline
        date.datePickerMode = .date
        return date
    }()
    
    lazy var rightQuestionsTextField: UITextField = {
        let rightQuestions = UITextField()
        rightQuestions.translatesAutoresizingMaskIntoConstraints = false
        rightQuestions.placeholder = "rightQuestions"
        return rightQuestions
    }()
    
    lazy var totalQuestionsTextField: UITextField = {
        let totalQuestions = UITextField()
        totalQuestions.translatesAutoresizingMaskIntoConstraints = false
        totalQuestions.placeholder = "totalQuestions"
        return totalQuestions
    }()
    
    lazy var addTestButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Test", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
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
}

// MARK: - UI Setup

extension TestPageView: ViewCodeProtocol {
    func setupUI() {

        addSubview(datePicker)
        addSubview(rightQuestionsTextField)
        addSubview(totalQuestionsTextField)
        addSubview(addTestButton)
        
        NSLayoutConstraint.activate([
            
            datePicker.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            rightQuestionsTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            rightQuestionsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            rightQuestionsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            totalQuestionsTextField.topAnchor.constraint(equalTo: rightQuestionsTextField.bottomAnchor, constant: 20),
            totalQuestionsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            totalQuestionsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            addTestButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addTestButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addTestButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addTestButton.widthAnchor.constraint(equalToConstant: 264),
            addTestButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

