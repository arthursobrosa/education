//
//  TestPageViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import UIKit

class TestPageViewController: UIViewController {
    // MARK: - ViewModel
    let viewModel: ThemePageViewModel
    
    // MARK: - Properties
    private lazy var themeRightQuestionsView: TestPageView = {
        let view = TestPageView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove os observadores ao sair da tela
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.themeRightQuestionsView
    }
    
    // MARK: - Methods
    func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: String(localized: "wrongQuestionsTitle"), message: String(localized: "wrongQuestionsMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y = -keyboardSize.height / 2
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        self.view.frame.origin.y = 0
    }
}
