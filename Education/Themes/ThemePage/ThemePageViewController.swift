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
    
    private var viewModel: ThemePageViewModel!
    private var themePageView: ThemePageView?
    
    // MARK: - Initialization
    
    init(viewModel: ThemePageViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.onFetchThemes = { [weak self] in
            self?.themePageView?.tableView.reloadData()
        }
        
        self.viewModel.onFetchInfo = { [weak self] in
               self?.updateViewWithFetchedInfo()
           }
        
        setupUI()
        fetchDataFromCoreData()
    }
    
    // MARK: - Update UI with Fetched Theme
    
    private func updateViewWithFetchedInfo() {
        guard let fetchedTheme = viewModel.getFetchedTheme() else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.themePageView?.titleLabel.text = fetchedTheme.name
        }
    }
    
    // MARK: - Fetch Data
    
    private func fetchDataFromCoreData() {
        self.viewModel.fetchInfo()
        self.viewModel.fetchItems()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        themePageView = ThemePageView(themeId: self.viewModel.themeId)
        guard let themePageView = themePageView else { return }
        themePageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themePageView)
        
        NSLayoutConstraint.activate([
            themePageView.topAnchor.constraint(equalTo: view.topAnchor),
            themePageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themePageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themePageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        themePageView.tableView.delegate = self
        themePageView.tableView.dataSource = self
        themePageView.tableView.register(TestTableViewCell.self, forCellReuseIdentifier: TestTableViewCell.identifier)
        themePageView.addThemeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc private func buttonTapped() {
        presentAddItemSheet()
    }
    
    private func presentAddItemSheet() {
        let vc = ThemeRigthQuestionsViewController(themeId: viewModel.themeId)
        vc.onTestAdded = { [weak self] in
            self?.viewModel.fetchItems() // Update table view when test is added
        }
        self.present(vc, animated: true)
    }
    
  
}

// MARK: - UITableViewDataSource

extension ThemePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let itemId = viewModel.items[indexPath.row].id {
                self.viewModel.removeItem(id: itemId)
                DispatchQueue.main.async {
                    self.themePageView?.tableView.reloadData()
                }
            } else {
                print("Error: Item ID not found.")
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension ThemePageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(viewModel.items[indexPath.row])")
    }
}

