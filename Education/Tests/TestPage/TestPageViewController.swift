//
//  TestPageViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class TestPageViewController: UIViewController {
    // MARK: - Properties
    
    private var viewModel: ThemePageViewModel!
    private lazy var themeRightQuestionsView: TestPageView = {
        let testView = TestPageView()
        testView.addTestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return testView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ThemePageViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.view = self.themeRightQuestionsView
    }
    
    // MARK: - UI Setup
    
    @objc private func buttonTapped() {
        if Int(self.themeRightQuestionsView.rightQuestionsTextField.text ?? "0") ?? 0 <= Int(self.themeRightQuestionsView.totalQuestionsTextField.text ?? "0") ?? 0{
            self.viewModel.addNewTest(
                date: self.themeRightQuestionsView.datePicker.date,
                rightQuestions: Int(self.themeRightQuestionsView.rightQuestionsTextField.text ?? "0") ?? 0,
                totalQuestions: Int(self.themeRightQuestionsView.totalQuestionsTextField.text ?? "0") ?? 0
            )
            self.dismiss(animated: true)
        }else {
            showWrongQuestionsAlert()
        }
    }
    
    // MARK: - Methods
    private func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: "Invalid Number of Hits!", message: "The number of correct answers cannot be greater than the total number of questions. Please review your entry.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
