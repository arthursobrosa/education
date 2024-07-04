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
    
    weak var coordinator: ShowingTestPage?
    private var tests = [Test]()
    private var viewModel: ThemePageViewModel!
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView(viewModel: self.viewModel)
        
        themeView.testsTableView.delegate = self
        themeView.testsTableView.dataSource = self
        themeView.testsTableView.register(TestTableViewCell.self, forCellReuseIdentifier: TestTableViewCell.identifier)
        
        themeView.addTestButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
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
            self.tests = tests.sorted{$0.date! > $1.date!}
            self.themePageView.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchTests()
    }
    
    // MARK: - Button method
    
    @objc private func buttonTapped() {
        self.coordinator?.showTestPage(viewModel: self.viewModel)
    }
}

// MARK: - UITableViewDataSource

extension ThemePageViewController: UITableViewDataSource {
    
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
}

// MARK: - UITableViewDelegate

extension ThemePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let test = self.tests[indexPath.row]
        print("Selected test: \(test)")
    }
}

