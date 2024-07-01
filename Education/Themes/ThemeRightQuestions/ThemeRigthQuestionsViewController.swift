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
    
    private var viewModel: ThemeRightQuestionsViewModel!
    private var themeRightQuestionsView: ThemeRightQuestionsView?
    private var themeId: String
    var onTestAdded: (() -> Void)?
    
    // MARK: - Initialization
    
    init(themeId: String) {
        self.themeId = themeId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        themeRightQuestionsView = ThemeRightQuestionsView()
        guard let themeRightQuestionsView = themeRightQuestionsView else { return }
        themeRightQuestionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeRightQuestionsView)
        
        NSLayoutConstraint.activate([
            themeRightQuestionsView.topAnchor.constraint(equalTo: view.topAnchor),
            themeRightQuestionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeRightQuestionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themeRightQuestionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        themeRightQuestionsView.addTestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        CoreDataManager.shared.createTest(themeID: themeId, date: themeRightQuestionsView?.datePicker.date ?? Date.now, rightQuestions: Int(themeRightQuestionsView?.rightQuestionsTextField.text ?? "-1") ?? -2, totalQuestions: Int(themeRightQuestionsView?.totalQuestionsTextField.text ?? "-1") ?? -2)
        
        onTestAdded?()
        self.dismiss(animated: true)
    }
    
}
