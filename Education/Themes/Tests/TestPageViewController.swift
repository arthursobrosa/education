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
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = self.viewModel.getTitle()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font : UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]
        
        let cancelButton = UIButton(configuration: .plain())
        let cancelAttributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font : UIFont(name: Fonts.darkModeOnRegular, size: 14) ?? .systemFont(ofSize: 14, weight: .regular), .foregroundColor : UIColor.secondaryLabel])
        cancelButton.setAttributedTitle(cancelAttributedString, for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        let cancelItem = UIBarButtonItem(customView: cancelButton)
        
        self.navigationItem.leftBarButtonItems = [cancelItem]
        
        if let _ = self.viewModel.test {
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(didTapDeleteButton))
            deleteButton.tintColor = UIColor(named: "FocusSettingsColor")
            
            self.navigationItem.rightBarButtonItems = [deleteButton]
        }
    }
    
    @objc private func didTapCancelButton() {
        self.coordinator?.dismiss(animated: true)
    }
    
    func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: String(localized: "wrongQuestionsTitle"), message: String(localized: "wrongQuestionsMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
