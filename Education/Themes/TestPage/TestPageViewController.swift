//
//  TestPageViewController.swift
//  Education
//
//  Created by Leandro Silva on 28/06/24.
//

import UIKit

class TestPageViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (Dismissing & DismissingAll)?
    let viewModel: TestPageViewModel

    // MARK: - UI Properties

    lazy var testPageView: TestPageView = {
        let title = viewModel.getTitle()
        let showsDeleteButton = viewModel.test != nil
        let view = TestPageView(title: title, showsDeleteButton: showsDeleteButton)

        view.delegate = self
        view.textView.delegate = self

        view.tableView.dataSource = self
        view.tableView.delegate = self

        return view
    }()

    // MARK: - Initializer

    init(viewModel: TestPageViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = testPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        testPageView.setUpTextView(withComment: viewModel.comment)
    }

    // MARK: - Methods

    func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: String(localized: "wrongQuestionsTitle"), message: String(localized: "wrongQuestionsMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showInvalidNameAlert() {
        let alertController = UIAlertController(title: String(localized: "invalidThemeName"), message: String(localized: "invalidThemeNameMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func textFieldEditingDidBegin(_ sender: UITextField) {
        sender.text = String()
    }

    @objc 
    func textFieldEditingDidEnd(_ sender: UITextField) {
        guard let text = sender.text else { return }

        switch sender.tag {
        case 0:
            let cleanName = text.trimmed()

            if cleanName.isEmpty {
                viewModel.themeName = ""
            } else {
                viewModel.themeName = cleanName
            }
        case 1:
            if text.isEmpty {
                sender.text = "0"
            }
                
            guard let intText = Int(text) else { return }
            viewModel.totalQuestions = intText
        case 2:
            if text.isEmpty {
                sender.text = "0"
            }
                
            guard let intText = Int(text) else { return }
            viewModel.rightQuestions = intText
        default:
            break
        }
    }

    @objc 
    func datePickerChanged(_ sender: UIDatePicker) {
        viewModel.date = sender.date
    }
}

// MARK: - Table View Data Source and Delegate
extension TestPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BorderedTableCell else { return }
        cell.configureCell(tableView: tableView, forRowAt: indexPath)
    }
    
    func numberOfSections(in _: UITableView) -> Int {
        viewModel.theme != nil ? 2 : 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfSections = tableView.numberOfSections
        
        if section == numberOfSections - 1 {
            return 2
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTableCell.identifier, for: indexPath) as? BorderedTableCell else {
            fatalError("Could not dequeue cell")
        }

        cell.textLabel?.text = getCellTitle(for: indexPath, numberOfSections: tableView.numberOfSections)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.textLabel?.textColor = .systemText

        cell.accessoryView = getAccessoryView(for: indexPath, numberOfSections: tableView.numberOfSections)

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        11
    }
}
