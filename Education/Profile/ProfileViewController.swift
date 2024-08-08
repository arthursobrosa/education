//
//  ProfileViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 07/08/24.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    weak var coordinator: ProfileCoordinator?
    private let viewModel: ProfileViewModel
    
    private lazy var profileView: ProfileView = {
        let view = ProfileView()
        
        view.settingsTableView.dataSource = self
        view.settingsTableView.delegate = self
        view.settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        return view
    }()
    
    let swiftUIFamilyPickerView = FamilyActivityPickerView()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.profileView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showFamilyActivityPicker() {
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        
        cell.textLabel?.text = "Select Blocked Apps"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            showFamilyActivityPicker()
        }
    }
    
}
