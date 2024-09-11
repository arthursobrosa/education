//
//  ThemePageViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import SwiftUI
import UIKit

class ThemePageViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingTestPage & Dismissing)?
    let viewModel: ThemePageViewModel
    
    // MARK: - Properties
    private var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()
        
        themeView.delegate = self
        
        themeView.translatesAutoresizingMaskIntoConstraints = false
        
        return themeView
    }()
    
    private let emptyView = EmptyView(message: String(localized: "emptyTest"))
    
    // MARK: - Initialization
    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.setNavigationItems()
        self.setupUI()
        
        self.viewModel.tests.bind { [weak self] tests in
            guard let self else { return }
            
            self.setContentView(isEmpty: tests.isEmpty)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchTests()
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = self.viewModel.theme.unwrappedName
        
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(addTestButtonTapped), for: .touchUpInside)
        addButton.tintColor = .label
        
        let addItem = UIBarButtonItem(customView: addButton)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteButton.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        deleteButton.tintColor = UIColor(named: "FocusSettingsColor")
        
        let deleteItem = UIBarButtonItem(customView: deleteButton)
        
        self.navigationItem.rightBarButtonItems = [deleteItem, addItem]
    }
    
    @objc private func addTestButtonTapped() {
        self.coordinator?.showTestPage(theme: self.viewModel.theme)
    }
    
    @objc private func didTapDeleteButton() {
        self.viewModel.removeTheme()
        self.coordinator?.dismiss(animated: true)
    }
    
    func setChart() {
        self.themePageView.customChart = CustomChart(limit: self.viewModel.selectedLimit)
        let limitedItems = self.viewModel.getLimitedItems()
        self.themePageView.customChart?.setData(limitedItems, sorter: \.date, mapTo: \.percentage)
    }
    
    func setTable() {
        self.themePageView.tableView = CustomTableView()
        self.themePageView.tableView?.delegate = self
        self.themePageView.tableView?.dataSource = self
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ThemePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tests.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = self.viewModel.tests.value[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as? CustomTableCell else {
            fatalError("Could not dequeue cell")
        }
        
        cell.textLabel?.text = self.viewModel.getDateString(from: test)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        
        let label = UILabel()
        label.text = self.viewModel.getQuestionsString(from: test)
        label.font = UIFont(name: Fonts.darkModeOnRegular, size: 16)
        label.textColor = .secondaryLabel
        label.sizeToFit()
        
        cell.accessoryView = label
        
        cell.row = indexPath.row
        cell.numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.viewModel.tests.value[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ThemePageViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(contentView)
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    private func setContentView(isEmpty: Bool) {
        self.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        self.themePageView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if !isEmpty {
            self.setTable()
            self.setChart()
        }
        
        self.addContentSubview(isEmpty ? self.emptyView : self.themePageView)
    }
    
    private func addContentSubview(_ subview: UIView) {
        self.contentView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: contentView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
