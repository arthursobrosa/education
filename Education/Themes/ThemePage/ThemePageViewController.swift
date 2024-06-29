//
//  ThemePageViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 27/06/24.
//

import Foundation
import UIKit

class ThemePageViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: Coordinator?
    private var tests = [Test]()
    private var viewModel: ThemePageViewModel!
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()
        themeView.tableView.delegate = self
        themeView.tableView.dataSource = self
        themeView.addThemeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return themeView
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
        
        self.view = self.themePageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.tests.bind { [weak self] tests in
            guard let self = self else { return }
            
            self.tests = tests
            self.themePageView.reloadTable()
        }
        
        fetchDataFromCoreData()
    }
    
    // MARK: - Fetch Data
    
    private func fetchDataFromCoreData() {
        self.viewModel.fetchTests()
    }
    
    @objc private func buttonTapped() {
        showAddItemAlert()
    }
    
    private func showAddItemAlert() {
        self.viewModel.addNewTest(date: Date.now, rightQuestions: 25, totalQuestions: 30)
    }
}

// MARK: - UITableViewDataSource

extension ThemePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let test = self.tests[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(test.rightQuestions)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let test = self.tests[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeTest(test)
        }
    }
}

// MARK: - UITableViewDelegate

extension ThemePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = self.tests[indexPath.row]
        print("Selected test: \(test)")
    }
}

