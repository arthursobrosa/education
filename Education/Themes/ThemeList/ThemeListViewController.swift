//
//  ThemeListViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import UIKit
import TipKit

class ThemeListViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: ShowingThemePage?
    private let viewModel: ThemeListViewModel
    
    var createTestTip = CreateTestTip()
    
    // MARK: - Properties
    private var themes = [Theme]()
    
    private lazy var themeListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let emptyView = EmptyView(message: String(localized: "emptyTheme"))
    
    // MARK: - Initialization
    init(viewModel: ThemeListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItems()
        
        self.viewModel.themes.bind { [weak self] themes in
            guard let self else { return }
            
            self.setView(isEmpty: themes.isEmpty)
            
            self.themes = themes
            self.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleTip()
        
        self.viewModel.fetchThemes()
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 32), forImageIn: .normal)
        addButton.addTarget(self, action: #selector(addThemeButtonTapped), for: .touchUpInside)
        addButton.tintColor = .label
        
        let addItem = UIBarButtonItem(customView: addButton)
        
        self.navigationItem.rightBarButtonItems = [addItem]
    }
    
    private func handleTip(){
        Task { @MainActor in
                for await shouldDisplay in createTestTip.shouldDisplayUpdates {
                    if shouldDisplay {
                        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
                            let controller = TipUIPopoverViewController(createTestTip, sourceItem: rightBarButtonItem)
                            controller.view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
                            present(controller, animated: true)
                        }
                    } else if presentedViewController is TipUIPopoverViewController {
                        dismiss(animated: true)
                    }
                }
            }
    }
    
    private func setView(isEmpty: Bool) {
        self.view = isEmpty ? self.emptyView : self.themeListTableView
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.themeListTableView.reloadData()
        }
    }
    
    @objc private func addThemeButtonTapped() {
        self.showAddThemeAlert()
    }
    
    private func showAddThemeAlert() {
        let alertController = UIAlertController(title: String(localized: "themeAlertTitle"), message: String(localized: "themeAlertMessage"), preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = String(localized: "themeAlertPlaceholder")
        }
        
        let addAction = UIAlertAction(title: String(localized: "add"), style: .default) { [weak self] _ in
            guard let self else { return }
            
            if let themeName = alertController.textFields?.first?.text, !themeName.isEmpty {
                self.viewModel.addTheme(name: themeName)
            }
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ThemeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = self.themes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        cell.textLabel?.text = theme.name
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        cell.accessoryView = createAccessoryView()
        
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    private func createAccessoryView() -> UIView {
        let containerView = UIView()
        
        let detailsLabel = UILabel()
        detailsLabel.text = String(localized: "themeTableDetail")
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 14)
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
            chevronImageView.leadingAnchor.constraint(equalTo: detailsLabel.trailingAnchor, constant: 4),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14) 
        ])
        
        containerView.frame.size = CGSize(width: 74, height: 20)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeTheme(theme: theme)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.row]
        self.coordinator?.showThemePage(theme: theme)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
