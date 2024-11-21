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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func loadView() {
        view = testPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()

        if viewModel.test == nil {
            testPageView.hideDeleteButton()
        }
        testPageView.textView.delegate = self
        setupTextView()
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationItem.title = viewModel.getTitle()
        navigationController?.navigationBar.tintColor = .systemText

        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]

        let cancelButton = UIButton(configuration: .plain())
        let regularFont: UIFont = UIFont(name: Fonts.darkModeOnRegular, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let cancelAttributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: UIColor.systemText50])
        cancelButton.setAttributedTitle(cancelAttributedString, for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        let cancelItem = UIBarButtonItem(customView: cancelButton)

        navigationItem.leftBarButtonItems = [cancelItem]
    }

    @objc 
    private func didTapCancelButton() {
        coordinator?.dismiss(animated: true)
    }

    func showWrongQuestionsAlert() {
        let alertController = UIAlertController(title: String(localized: "wrongQuestionsTitle"), message: String(localized: "wrongQuestionsMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    func textFieldEditingDidBegin(_ sender: UITextField) {
        if sender.tag == 0 {
            sender.textColor = .systemText
            sender.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
            sender.text = String()
        }else{
            sender.text = String()
        }
    }

    @objc 
    func textFieldEditingDidEnd(_ sender: UITextField) {
        guard let text = sender.text else { return }

        switch sender.tag {
        case 0:
            viewModel.themeName = text
            
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

    func setupTextView() {
        if viewModel.comment.isEmpty {
            testPageView.textView.text = String(localized: "description")
            testPageView.textView.font = UIFont(name: Fonts.darkModeOnItalic, size: 16)
            testPageView.textView.textColor = .systemText40
        } else {
            testPageView.textView.text = viewModel.comment
            testPageView.textView.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
            testPageView.textView.textColor = .systemText
        }
    }

    @objc 
    func datePickerChanged(_ sender: UIDatePicker) {
        viewModel.date = sender.date
    }
}

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
