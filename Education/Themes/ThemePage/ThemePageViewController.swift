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
    private var tests = [Test]()
    
    private var contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()
        
        themeView.delegate = self
        
        let chartView = ChartView(viewModel: self.viewModel)
        themeView.chartHostingController = UIHostingController(rootView: chartView)
        
        themeView.testsTableView.delegate = self
        themeView.testsTableView.dataSource = self
        themeView.testsTableView.register(TestTableViewCell.self, forCellReuseIdentifier: TestTableViewCell.identifier)
        
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
            
            self.tests = tests.sorted { $0.date! > $1.date! }
            self.reloadTable()
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
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.themePageView.testsTableView.reloadData()
        }
    }
    
    @objc private func addTestButtonTapped() {
        self.coordinator?.showTestPage(viewModel: self.viewModel)
    }
    
    @objc private func didTapDeleteButton() {
        self.viewModel.removeTheme()
        self.coordinator?.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ThemePageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = self.tests[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }
        
        cell.test = test
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let test = self.tests[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeTest(test)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.tests[indexPath.row]
        
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
        self.view.removeConstraints(self.emptyView.constraints)
        self.view.removeConstraints(self.themePageView.constraints)
        
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
