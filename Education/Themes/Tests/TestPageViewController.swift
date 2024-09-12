//
//  TestPageViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import UIKit

class TestPageViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: Dismissing?
    let viewModel: TestPageViewModel
    
    // MARK: - Properties
    private lazy var testPageView: TestPageView = {
        let view = TestPageView()
        
        view.delegate = self
        
        view.tableView.dataSource = self
        view.tableView.delegate = self
        
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: TestPageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.testPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove os observadores ao sair da tela
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = self.viewModel.getTitle()
        
        let cancelButton = UIBarButtonItem(title: String(localized: "cancel"), style: .plain, target: self, action: #selector(didTapCancelButton))
        cancelButton.tintColor = .secondaryLabel
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        
        if let test = self.viewModel.test {
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(didTapDeleteButton))
            deleteButton.tintColor = UIColor(named: "FocusSettingsColor")
            
            self.navigationItem.rightBarButtonItems = [deleteButton]
        }
    }
    
    @objc private func didTapCancelButton() {
        print(#function)
    }
    
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
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        if text.isEmpty {
            sender.text = "0"
        }
        
        guard let intText = Int(text) else { return }
        
        switch sender.tag {
            case 0:
                self.viewModel.totalQuestions = intText
            case 1:
                self.viewModel.rightQuestions = intText
            default:
                break
        }
    }
    
    @objc func doneKeyboardButtonTapped(_ sender: UIBarButtonItem) {
        guard let cell = self.testPageView.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 1)),
              let textField = cell.accessoryView as? UITextField else { return }
        
        textField.resignFirstResponder()
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        self.viewModel.date = sender.date
    }
    
    @objc private func didTapDeleteButton() {
        self.viewModel.removeTest()
        
        self.coordinator?.dismiss(animated: true)
    }
}

extension TestPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 2
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as? CustomTableCell else {
            fatalError("Could not dequeue cell")
        }
        
        cell.textLabel?.text = self.getCellTitle(for: indexPath)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .label
        
        cell.accessoryView = self.getAccessoryView(for: indexPath)
        
        cell.row = indexPath.row
        cell.numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        
        return cell
    }
}
