//
//  FocusSessionSettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit

class FocusSessionSettingsViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: ShowingTimer?
    let viewModel: FocusSessionSettingsViewModel
    
    // MARK: - Properties
    lazy var timerSettingsView: FocusSessionSettingsView = {
        let view = FocusSessionSettingsView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        return view
    }()
    
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
        
        self.viewModel.selectedTime = 0
        self.viewModel.selectedSchedule = self.viewModel.schedules[0]
        self.reloadTable()
        
        guard let cell = self.timerSettingsView.tableView.cellForRow(at: IndexPath(row: 0, section: 1)),
              let datePicker = cell.accessoryView as? UIDatePicker else { return }
        
        datePicker.date = Date.now
    }
    
    // MARK: - Auxiliar Methods
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.timerSettingsView.tableView.reloadData()
        }
    }
    
    private func showInvalidDateAlert() {
        let alertController = UIAlertController(title: "Invalid date", message: "You chose an invalid date", preferredStyle: .alert)
        
        let chooseAgainAction = UIAlertAction(title: "Choose again", style: .default)

        alertController.addAction(chooseAgainAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Button Actions
extension FocusSessionSettingsViewController {
    @objc private func startButtonClicked() {
        if self.viewModel.selectedTime <= 0 {
            self.showInvalidDateAlert()
            return
        }
        
        self.coordinator?.showTimer(Int(self.viewModel.selectedTime))
    }
    
    @objc func timerPickerChange(_ sender: UIDatePicker) {
        let totalTime = self.viewModel.getTotalSeconds(fromDate: sender.date)
        
        self.viewModel.selectedTime = TimeInterval(totalTime) // Update the selectedTime variable
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FocusSessionSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return 2
            case 2:
                if self.viewModel.blockApps {
                    return 2
                }
                
                return 1
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
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
                return "Subject" 
            case 1:
                return "Timer"
            case 2:
                return "App Blocking"
            default:
                return String()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            if let popover = self.createSchedulePopover(forTableView: tableView, at: indexPath) {
                self.present(popover, animated: true)
            }
        }
    }
}

#Preview {
    let coordinator = FocusSessionSettingsCoordinator(navigationController: UINavigationController())
    coordinator.start()
    
    return coordinator.navigationController
}
