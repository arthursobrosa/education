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
    
    weak var coordinator: ShowingThemePage?
    private var themes = [Theme]()
    private var viewModel: ThemeListViewModel!
    private lazy var themeListView: ThemeListView = {
        let themeView = ThemeListView()
        
        themeView.tableView.delegate = self
        themeView.tableView.dataSource = self
        themeView.addThemeButton.addTarget(self, action: #selector(addThemeButtonTapped), for: .touchUpInside)
        
        return themeView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ThemeListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.themeListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.themes.bind { [weak self] themes in
            guard let self = self else { return }
            
            self.themes = themes
            self.themeListView.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchThemes()
    }
    
    // MARK: - User Actions
    
    @objc private func addThemeButtonTapped() {
        showAddThemeAlert()
    }
    
    private func showAddThemeAlert() {
        let alertController = UIAlertController(title: "Add Theme", message: "Enter theme name:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Theme name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if let themeName = alertController.textFields?.first?.text, !themeName.isEmpty {
                self.viewModel.addTheme(name: themeName)
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
        return self.themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = self.themes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = theme.name
        cell.accessoryView = createAccessoryView()
        
        if self.traitCollection.userInterfaceStyle == .light {
            cell.backgroundColor = .systemGray5
        }
        
        
        return cell
    }
    
    private func createAccessoryView() -> UIView {
        let containerView = UIView()
        
        let detailsLabel = UILabel()
        detailsLabel.text = "Detail"
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.font = UIFont.systemFont(ofSize: 17)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .secondaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(detailsLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            detailsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor, constant: 0),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14) 
        ])
        
        containerView.frame.size = CGSize(width: 63, height: 20)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeTheme(theme: theme)
        }
    }

}

// MARK: - UITableViewDelegate

extension ThemeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.row]
        self.coordinator?.showThemePage(theme: theme)
    }
}
