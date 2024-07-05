//
//  FocusSessionSettingsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit

class FocusSessionSettingsViewController: UIViewController {
    weak var coordinator: ShowingTimer?
    private let viewModel: FocusSessionSettingsViewModel
    private lazy var timerSettingsView: FocusSessionSettingsView = {
        let view = FocusSessionSettingsView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        return view
    }()
    
    private lazy var selectedSubject: String = self.viewModel.selectedSubject.value
    
    init(viewModel: FocusSessionSettingsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.timerSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.selectedSubject.bind { [weak self] selectedSubject in
            guard let self = self else { return }
            
            self.selectedSubject = selectedSubject
            self.reloadTable()
        }
    }
    
    @objc private func startButtonClicked() {
        self.coordinator?.showTimer(Int(self.viewModel.selectedTime))
    }
    
    @objc private func timerPickerChange(_ sender: UIDatePicker) {
        let totalTime = self.viewModel.getTotalSeconds(fromDate: sender.date)
        
        if totalTime <= 0 {
            // TODO: - Error
            return
        }
        
        self.viewModel.selectedTime = TimeInterval(totalTime) // Update the selectedTime variable
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.timerSettingsView.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FocusSessionSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.viewModel.isOpened ? (self.viewModel.subjects.count + 1) : 1
            case 1, 2:
                return 2
            case 3:
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
            case 3:
                return "Goals"
            default:
                return String()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 && row == 0 {
            self.viewModel.isOpened.toggle()
            self.reloadTable()
        }
    }
}

// MARK: - Cell Configuration
private extension FocusSessionSettingsViewController {
    func createCellTitle(for indexPath: IndexPath) -> String {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                if row == 0 {
                    return self.viewModel.selectedSubject.value
                }
                   
                return self.viewModel.subjects[row - 1]
            case 1:
                if row == 0 {
                    return "Ends at"
                }
                
                return "Alarm when finished"
            case 2:
                if row == 0 {
                    return "Block"
                }
                
                return "Apps"
            case 3:
                return "Study Goals"
            default:
                return String()
        }
    }
    
    func createAccessoryView(for indexPath: IndexPath) -> UIView? {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                if row == 0 {
                    return UIImageView(image: UIImage(systemName: "chevron.down"))
                } else {
                    let toggle = self.createToggle(for: indexPath)
                    return toggle
                }
            case 1:
                if row == 0 {
                    let datePicker = UIDatePicker()
                    datePicker.datePickerMode = .time
                    datePicker.addTarget(self, action: #selector(timerPickerChange(_:)), for: .valueChanged)
                    return datePicker
                } else {
                    let toggle = self.createToggle(for: indexPath)
                    return toggle
                }
            case 2:
                if row == 0 {
                    let toggle = self.createToggle(for: indexPath)
                    return toggle
                } else {
                    return UIImageView(image: UIImage(systemName: "chevron.right"))
                }
            default:
                return nil
        }
    }
}

// MARK: - Toggle methods
private extension FocusSessionSettingsViewController {
    func createToggle(for indexPath: IndexPath) -> UISwitch {
        let section = indexPath.section
        let row = indexPath.row
        
        let toggle = UISwitch()
        
        var selector = Selector(String())
        var isOn: Bool = false
        
        switch section {
            case 0:
                selector = #selector(subjectToggleSwitched(_:))
                toggle.tag = row - 1
                
                if let selectedData = self.viewModel.subjects.first(where: { $0 == self.viewModel.subjects[row - 1] }) {
                    isOn = selectedData == self.viewModel.selectedSubject.value
                }
            case 1:
                selector = #selector(alarmToggleSwiched(_:))
                isOn = self.viewModel.alarmWhenFinished
            case 2:
                selector = #selector(blockAppToggleSwitched(_:))
                isOn = self.viewModel.blockApps
            default:
                break
        }
        
        toggle.addTarget(self, action: selector, for: .valueChanged)
        toggle.isOn = isOn
        
        return toggle
    }
    
    @objc func blockAppToggleSwitched(_ sender: UISwitch) {
        self.viewModel.blockApps = sender.isOn
    }
    
    @objc func alarmToggleSwiched(_ sender: UISwitch) {
        self.viewModel.alarmWhenFinished = sender.isOn
    }
    
    @objc func subjectToggleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            self.unselectedToggles(sender.tag)
        } else {
            self.selectNoneToggle()
        }
        
        self.viewModel.selectedSubject.value = self.viewModel.subjects[(sender.isOn ? sender.tag : 0)]
    }
    
    func unselectedToggles(_ tag: Int) {
        for i in 0..<self.viewModel.subjects.count {
            let indexPath = IndexPath(row: i + 1, section: 0)
            let cell = self.timerSettingsView.tableView.cellForRow(at: indexPath)
            let toggle = cell?.accessoryView as! UISwitch
            
            if tag != toggle.tag {
                toggle.setOn(false, animated: true)
            }
        }
    }
    
    func selectNoneToggle() {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.timerSettingsView.tableView.cellForRow(at: indexPath)
        let toggle = cell?.accessoryView as! UISwitch
        toggle.isOn = true
        self.viewModel.selectedSubject.value = self.viewModel.subjects[toggle.tag]
    }
}

#Preview {
    FocusSessionSettingsViewController(viewModel: FocusSessionSettingsViewModel())
}
