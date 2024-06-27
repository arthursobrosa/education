//
//  ThemeListViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import Foundation
import UIKit

class ThemeListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: ThemeListViewModel!
    private var themeListView: ThemeListView?
    
    // MARK: - Initialization
    
    init(viewModel: ThemeListViewModel) {
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
            self?.themeListView?.tableView.reloadData()
        }
        
        setupUI()
        fetchDataFromCoreData()
    }
    
    // MARK: - Fetch Data
    
    private func fetchDataFromCoreData() {
        self.viewModel.fetchItems()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        
        themeListView = ThemeListView()
        guard let themeListView = themeListView else { return }
        themeListView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(themeListView)
        
        NSLayoutConstraint.activate([
            themeListView.topAnchor.constraint(equalTo: view.topAnchor),
            themeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            themeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        themeListView.tableView.delegate = self
        themeListView.tableView.dataSource = self
        themeListView.addThemeButton.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - User Actions
    
    @objc private func addItemButtonTapped() {
        showAddItemAlert()
    }
    
    private func showAddItemAlert() {
        let alertController = UIAlertController(title: "Add Item", message: "Enter item name:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Item name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let itemName = alertController.textFields?.first?.text, !itemName.isEmpty {
                
                self?.viewModel.addNewItem(name: itemName)
                self?.themeListView?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ThemeListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ThemeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(viewModel.items[indexPath.row])")
    }
}
