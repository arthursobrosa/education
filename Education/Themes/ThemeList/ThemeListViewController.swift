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
    weak var coordinator: (ShowingThemePage & ShowingThemeCreation)?
    let viewModel: ThemeListViewModel
    
    var createTestTip = CreateTestTip()
    
    // MARK: - Properties
    private var themes = [Theme]()
    
    lazy var themeListView: ThemeListView = {
        let view = ThemeListView()
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(ThemeListCell.self, forCellReuseIdentifier: ThemeListCell.identifier)
        
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
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.themeListView.tableView.reloadData()
        }
    }
}

@objc protocol ThemeListDelegate: AnyObject {
    func addThemeButtonTapped()
}

extension ThemeListViewController: ThemeListDelegate {
    func addThemeButtonTapped() {
        self.coordinator?.showThemeCreation(theme: nil)
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
        let theme = self.themes[indexPath.section]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeListCell.identifier, for: indexPath) as? ThemeListCell else {
            fatalError("Could not dequeue cell")
        }
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .label
        
        cell.accessoryView = chevronImageView
        
        cell.backgroundColor = .systemBackground
        
        cell.roundCorners(corners: .allCorners, radius: 18, borderWidth: 2, borderColor: .systemGray4)
        
        let cellContent = self.getCellContent(from: theme)
        cell.configureContentView(with: cellContent)
        
        return cell
    }
    
    private func getCellContent(from theme: Theme) -> UIView {
        let nameLabel = UILabel()
        nameLabel.text = theme.unwrappedName
        nameLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let test = self.viewModel.getMostRecentTest(from: theme) {
            let dateLabel = UILabel()
            dateLabel.text = self.viewModel.getThemeDescription(with: test)
            dateLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)
            dateLabel.textColor = .secondaryLabel
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(nameLabel)
            stack.addArrangedSubview(dateLabel)
            
            return stack
        }
            
        return nameLabel
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = self.themes[indexPath.section]
        self.coordinator?.showThemePage(theme: theme)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let theme = self.viewModel.themes.value[indexPath.section]
        
        let editButton = UIContextualAction(style: .normal, title: "") { _, _, _ in
            self.coordinator?.showThemeCreation(theme: theme)
        }
        
        editButton.backgroundColor = .systemBackground
        let editImage = UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysOriginal).withTintColor(.label)
        editButton.image = editImage
        
        let deleteButton = UIContextualAction(style: .normal, title: "") { _, _, _ in
            self.viewModel.removeTheme(theme)
            self.viewModel.fetchThemes()
        }
        
        deleteButton.backgroundColor = .systemBackground
        let deleteImage = UIImage(systemName: "trash.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        deleteButton.image = deleteImage
        
        return UISwipeActionsConfiguration(actions: [deleteButton, editButton])
    }
}
