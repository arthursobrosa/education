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
    let viewModel: ThemeListViewModel
    
    var createTestTip = CreateTestTip()
    
    // MARK: - Properties
    private var themes = [Theme]()
    
    lazy var themeListView: ThemeListView = {
        let view = ThemeListView()
        
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        return view
    }()
    
    // MARK: - Initialization
    init(viewModel: ThemeListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.themeListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationItems()
        
        self.viewModel.themes.bind { [weak self] themes in
            guard let self else { return }
            
            self.themes = themes
            self.reloadTable()
            
            self.setContentView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.handleTip()
        
        self.viewModel.fetchThemes()
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(addThemeButtonTapped), for: .touchUpInside)
        addButton.tintColor = .label
        
        let addItem = UIBarButtonItem(customView: addButton)
        
        self.navigationItem.rightBarButtonItems = [addItem]
        
        self.navigationItem.title = String(localized: "themeTab")
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: Fonts.coconRegular, size: Fonts.titleSize)!, .foregroundColor : UIColor.label]
    }
    
    private func handleTip() {
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
    
    private func setContentView() {
        self.themeListView.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let isEmpty = self.themes.isEmpty
        
        self.addContentSubview(isEmpty ? self.themeListView.emptyView : self.themeListView.tableView)
    }
    
    private func addContentSubview(_ subview: UIView) {
        self.themeListView.contentView.addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.themeListView.contentView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: self.themeListView.contentView.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: self.themeListView.contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.themeListView.contentView.trailingAnchor)
        ])
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.themeListView.tableView.reloadData()
        }
    }
    
    @objc private func addThemeButtonTapped() {
        self.showNewThemeAlert()
    }
    
    private func showNewThemeAlert() {
        self.themeListView.newThemeAlert.isHidden = false
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ThemeListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.themes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = self.themes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        cell.textLabel?.text = theme.name
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .label
        
        cell.accessoryView = chevronImageView
        
        cell.backgroundColor = .systemBackground
        
        cell.roundCorners(corners: .allCorners, radius: 18, borderWidth: 2, borderColor: .secondaryLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 11
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
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

extension ThemeListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.viewModel.newThemeName = text
    }
}
