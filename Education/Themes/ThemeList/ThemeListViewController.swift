//
//  ThemeListViewController.swift
//  Education
//
//  Created by Eduardo Dalencon on 26/06/24.
//

import TipKit
import UIKit

class ThemeListViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (ShowingThemePage & ShowingThemeCreation & ShowingTestPage)?
    let viewModel: ThemeListViewModel

    var createTestTip = CreateTestTip()

    // MARK: - Properties

    var themes = [Theme]()

    lazy var themeListView: ThemeListView = {
        let view = ThemeListView()
        view.delegate = self

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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = themeListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()

        viewModel.themes.bind { [weak self] themes in
            guard let self else { return }

            self.themes = themes
            self.reloadTable()

            self.setContentView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        handleTip()
        viewModel.fetchThemes()
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        themeListView.setNavigationBar()
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
        for subview in themeListView.contentView.subviews {
            subview.removeFromSuperview()
        }

        let isEmpty = themes.isEmpty

        addContentSubview(isEmpty ? themeListView.emptyView : themeListView.tableView)
    }

    private func addContentSubview(_ subview: UIView) {
        themeListView.contentView.addSubview(subview)

        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: themeListView.contentView.topAnchor),
            subview.bottomAnchor.constraint(equalTo: themeListView.contentView.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: themeListView.contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: themeListView.contentView.trailingAnchor),
        ])
    }

    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.themeListView.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ThemeListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in _: UITableView) -> Int {
        return themes.count
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = themes[indexPath.section]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeListCell.identifier, for: indexPath) as? ThemeListCell else {
            fatalError("Could not dequeue cell")
        }

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .systemText80

        cell.accessoryView = chevronImageView

        cell.backgroundColor = .systemBackground

        cell.roundCorners(corners: .allCorners, radius: 18, borderWidth: 2, borderColor: .buttonNormal)

        let cellContent = getCellContent(from: theme)
        cell.configureContentView(with: cellContent)

        return cell
    }

    private func getCellContent(from theme: Theme) -> UIView {
        let nameLabel = UILabel()
        nameLabel.text = theme.unwrappedName
        nameLabel.font = UIFont(name: Fonts.darkModeOnSemiBold, size: 16)
        nameLabel.textColor = .systemText80
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        if let test = viewModel.getMostRecentTest(from: theme) {
            let dateLabel = UILabel()
            dateLabel.text = viewModel.getThemeDescription(with: test)
            dateLabel.font = UIFont(name: Fonts.darkModeOnRegular, size: 15)
            dateLabel.textColor = .systemText50
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

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 77
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 0
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 11
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = themes[indexPath.section]
        coordinator?.showThemePage(theme: theme)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let theme = viewModel.themes.value[indexPath.section]
        viewModel.selectedThemeIndex = indexPath.section

        let editButton = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            guard let self else { return }

            self.coordinator?.showThemeCreation(theme: theme)
        }

        editButton.backgroundColor = .systemBackground
        let editImage = UIImage(systemName: "square.and.pencil")?.withRenderingMode(.alwaysOriginal).withTintColor(UIColor(named: "system-text") ?? .red)
        editButton.image = editImage

        let deleteButton = UIContextualAction(style: .normal, title: "") { [weak self] _, _, _ in
            guard let self else { return }

            self.trashButtonTapped()
        }

        deleteButton.backgroundColor = .systemBackground
        let deleteImage = UIImage(systemName: "trash")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        deleteButton.image = deleteImage

        return UISwipeActionsConfiguration(actions: [deleteButton, editButton])
    }
}
