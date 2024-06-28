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
            
            // Update the title label in the view with the fetched theme's name
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
        
        themePageView = ThemePageView()
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
        
        themePageView.addThemeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
    }
    
    @objc private func buttonTapped() {
        showAddItemAlert()
    }
    
    private func showAddItemAlert() {
        self.viewModel.addNewItem()
    }
    
  
}

// MARK: - UITableViewDataSource

extension ThemePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = String(viewModel.items[indexPath.row].rightQuestions)
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

