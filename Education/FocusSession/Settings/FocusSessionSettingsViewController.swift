//
//  FocusSessionSettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit
import FamilyControls
import SwiftUI

class FocusSessionSettingsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: ShowingTimer?
    let viewModel: FocusSessionSettingsViewModel
    
    // MARK: - Properties
    lazy var timerSettingsView: FocusSessionSettingsView = {
        let view = FocusSessionSettingsView()
        
        view.delegate = self
        
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        view.tableView.delegate = self
        view.tableView.dataSource = self
        
        return view
    }()
    
    var isPopoverOpen: Bool = false {
        didSet {
            guard let timerCell = self.timerSettingsView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
                  let datePicker = timerCell.accessoryView as? UIDatePicker else { return }
            
            datePicker.isEnabled = !isPopoverOpen
        }
    }
    
    // MARK: - Initializer
    init(viewModel: FocusSessionSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.timerSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSubjects()
        
        self.viewModel.selectedDate = Date.now
        self.viewModel.selectedSubjectName = self.viewModel.subjectsNames[0]
        self.reloadTable()
        
        guard let cell = self.timerSettingsView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
              let datePicker = cell.accessoryView as? UIDatePicker else { return }
        
        datePicker.date = Date.now
    }
    
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.timerSettingsView.tableView.reloadData()
        }
    }
    
    func showInvalidDateAlert() {
        let alertController = UIAlertController(title: String(localized: "focusInvalidDateAlertTitle"), message: String(localized: "focusInvalidDateAlertMessage"), preferredStyle: .alert)
        
        let chooseAgainAction = UIAlertAction(title: String(localized: "focusInvalidDateAction"), style: .default)

        alertController.addAction(chooseAgainAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Button Actions
extension FocusSessionSettingsViewController {
    @objc func timerPickerChange(_ sender: UIDatePicker) {
        self.viewModel.selectedDate = sender.date
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension FocusSessionSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        cell.textLabel?.text = self.createCellTitle(for: indexPath)
        cell.accessoryView = self.createAccessoryView(for: indexPath)
        
        if self.traitCollection.userInterfaceStyle == .light {
            cell.backgroundColor = .systemGray5
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0:
                return String(localized: "focusTableSubjectHeader")
            case 1:
                return String(localized: "focusTableTimerHeader")
            case 2:
                return String(localized: "focusTableAppBlockingHeader")
            default:
                return String()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            if let popover = self.createSchedulePopover(forTableView: tableView, at: indexPath) {
                self.isPopoverOpen.toggle()
                self.present(popover, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#Preview {
    let coordinator = FocusSessionSettingsCoordinator(navigationController: UINavigationController())
    coordinator.start()
    
    return coordinator.navigationController
}
