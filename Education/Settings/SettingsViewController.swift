//
//  SettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import SwiftUI
import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    
    weak var coordinator: SettingsCoordinator?
    let viewModel: SettingsViewModel

    // MARK: - Properties
    
    private let blockingManager: BlockingManager

    // MARK: - UI Properties
    
    lazy var settingsView: SettingsView = {
        let view = SettingsView()
        
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        return view
    }()

    private lazy var swiftUIFamilyPickerView: FamilyActivityPickerView = .init(pickerDelegate: blockingManager)

    // MARK: - Initializer
    
    init(viewModel: SettingsViewModel, blockingManger: BlockingManager) {
        self.viewModel = viewModel
        self.blockingManager = blockingManger

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        viewModel.isNotificationActive.bind { [weak self] _ in
            guard let self else { return }

            self.reloadTable()
        }

        setNavigationItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.requestNoficationsAuthorization()
    }

    // MARK: - Methods
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.settingsView.tableView.reloadData()
        }
    }

    private func setNavigationItems() {
        settingsView.setNavigationBar()
    }

    private func showFamilyActivityPicker() {
        // Create the hosting controller with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIFamilyPickerView)

        let swiftuiView = hostingController.view
        swiftuiView?.translatesAutoresizingMaskIntoConstraints = false

        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        
        guard let swiftuiView else { return }

        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftuiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        hostingController.didMove(toParent: self)
    }

    @objc 
    func didChangeNotificationToggle(_ sender: UISwitch) {
        sender.setOn(!sender.isOn, animated: true)

        showNotificationAlert(isActivating: !sender.isOn)
    }

    private func showNotificationAlert(isActivating: Bool) {
        let deactivationTitle = String(localized: "deactivateTitle")
        let deactivationMessage = String(localized: "deactivateMessage")

        let activationTitle = String(localized: "activationTitle")
        let activationMessage = String(localized: "activationMessage")

        var actions = [UIAlertAction]()

        let activateNowAction = UIAlertAction(title: String(localized: "activateNow"), style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let activateLaterAction = UIAlertAction(title: String(localized: "activateLater"), style: .destructive)

        let okAction = UIAlertAction(title: String(localized: "okAction"), style: .cancel, handler: nil)

        let title = isActivating ? activationTitle : deactivationTitle
        let message = isActivating ? activationMessage : deactivationMessage
        actions = isActivating ? [activateNowAction, activateLaterAction] : [okAction]

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for action in actions {
            alert.addAction(action)
        }

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Could not dequeue cell")
        }

        let items: [SettingsCase] = SettingsCase.allCases
        let row = indexPath.row

        let item = items[row]

        let image = UIImage(systemName: item.iconName)

        cell.configure(withText: item.title, withImage: image)
        cell.setAccessoryView(createCellAccessoryView(for: row))

        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row

        switch row {
        case 1:
            showFamilyActivityPicker()
        case 2:
            if let popover = createDayPopover(forTableView: tableView, at: indexPath) {
                present(popover, animated: true)
            }
        default:
            return
        }
    }
}
