//
//  SettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    let viewModel: SettingsViewModel
    
    private let blockingManager: BlockingManager
    
    lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var swiftUIFamilyPickerView: FamilyActivityPickerView = FamilyActivityPickerView(pickerDelegate: blockingManager)
    
    init(viewModel: SettingsViewModel, blockingManger: BlockingManager) {
        self.viewModel = viewModel
        self.blockingManager = blockingManger
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.viewModel.isNotificationActive.bind { [weak self] isActive in
            guard let self else { return }
            
            self.reloadTable()
        }
        
        self.setNavigationItems()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.requestNoficationsAuthorization()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.settingsTableView.reloadData()
        }
    }
    
    private func setNavigationItems() {
        self.navigationItem.title = String(localized: "settingsTab")
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: Fonts.coconRegular, size: Fonts.titleSize)!, .foregroundColor : UIColor.label]
    }
    
    private func showFamilyActivityPicker() {
        // Create the hosting controller with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIFamilyPickerView)
        
        let swiftuiView = hostingController.view!
            swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            swiftuiView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftuiView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @objc func didChangeNotificationToggle(_ sender: UISwitch) {
        sender.setOn(!sender.isOn, animated: true)
        
        self.showNotificationAlert(isActivating: !sender.isOn)
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
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.configure(withText: item.title, withImage: image!)
        cell.setAccessoryView(self.createCellAccessoryView(for: row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
            case 1:
                self.showFamilyActivityPicker()
            case 2:
                if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                    self.present(popover, animated: true)
                }
            default:
                return
        }
    }
}

extension SettingsViewController: ViewCodeProtocol {
    func setupUI() {
        self.view.addSubview(settingsTableView)
        
        let padding = 12.0
        
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            settingsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            settingsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding)
        ])
    }
}
