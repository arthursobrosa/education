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
    weak var coordinator: ShowingTestPage?
    let viewModel: ThemePageViewModel
    
    // MARK: - Properties
    private var tests = [Test]()
    private lazy var themePageView: ThemePageView = {
        let themeView = ThemePageView()
        
        themeView.delegate = self
        
        let chartView = ChartView(viewModel: self.viewModel)
        themeView.chartHostingController = UIHostingController(rootView: chartView)
        
        themeView.testsTableView.delegate = self
        themeView.testsTableView.dataSource = self
        themeView.testsTableView.register(TestTableViewCell.self, forCellReuseIdentifier: TestTableViewCell.identifier)
        
        return themeView
    }()
    
    // MARK: - Initialization
    init(viewModel: ThemePageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.themePageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.tests.bind { [weak self] tests in
            guard let self = self else { return }
            self.tests = tests.sorted{$0.date! > $1.date!}
            self.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchTests()
    }
    
    // MARK: - Button method
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.themePageView.testsTableView.reloadData()
        }
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
