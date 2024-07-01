//
//  ThemeRigthQuestionsViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import Foundation
import UIKit

class ThemeRigthQuestionsViewController: UIViewController {
    // MARK: - Properties
    
    private var viewModel: ThemePageViewModel!
    private lazy var themeRightQuestionsView: ThemeRightQuestionsView = {
        let view = ThemeRightQuestionsView()
        view.addTestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return view
    }()
    
    var onTestAdded: (() -> Void)?
    
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
        self.viewModel.addNewTest(
            date: self.themeRightQuestionsView.datePicker.date,
            rightQuestions: Int(self.themeRightQuestionsView.rightQuestionsTextField.text ?? "-1") ?? -2,
            totalQuestions: Int(self.themeRightQuestionsView.totalQuestionsTextField.text ?? "-1") ?? -2
        )
        
        self.dismiss(animated: true)
    }
}
