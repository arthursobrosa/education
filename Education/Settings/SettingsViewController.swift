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
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        return tableView
    }()
    
    private let swiftUIFamilyPickerView = FamilyActivityPickerView()
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.settingsTableView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.isNotificationActive.bind { [weak self] isActive in
            guard let self else { return }
            
            self.reloadTable()
        }
        
        self.navigationItem.title = String(localized: "settingsTab")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.requestNoficationAuthorization()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.settingsTableView.reloadData()
        }
    }
    
    private func showFamilyActivityPicker() {
        // Create the SwiftUI view
        let swiftUIView = FamilyActivityPickerView()
        
        // Create the hosting controller with the SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIView)
        
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

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        
        cell.textLabel?.text = self.createCellTitle(for: indexPath)
        cell.accessoryView = self.createCellAccessoryView(for: indexPath)
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        switch row {
            case 1:
                self.showFamilyActivityPicker()
            default:
                return
        }
    }
}
