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
    private let viewModel: SettingsViewModel
    
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
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        
        var cellText = String()
        
        switch section {
            case 0:
                cellText = String(localized: "selectBlockedApps")
            case 1:
                cellText = String(localized: "activateNotification")
            default:
                break
        }
        
        cell.textLabel?.text = cellText
        cell.backgroundColor = .systemGray6
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
      
        switch section {
            case 0:
                self.showFamilyActivityPicker()
            case 1:
                self.viewModel.requestNoficationAuthorization()
            default:
                break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return String(localized: "blockAppsTitle")
            case 1:
                return String(localized: "notificationsTitle")
            default:
                return String()
        }
    }
}
