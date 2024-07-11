//
//  ScheduleCreationViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

protocol ScheduleCreationDelegate: AnyObject {
    func saveSchedule()
}

class ScheduleCreationViewController: UIViewController {
    private let viewModel: ScheduleCreationViewModel
    
    private lazy var scheduleCreationView: ScheduleCreationView = {
        let view = ScheduleCreationView()
        view.delegate = self
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        return view
    }()
    
    init(viewModel: ScheduleCreationViewModel = ScheduleCreationViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = self.scheduleCreationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.scheduleCreationView.tableView.reloadData()
        }
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        switch sender.tag {
            case 0:
                self.viewModel.selectedStartTime = sender.date
            case 1:
                self.viewModel.selectedEndTime = sender.date
            default:
                break
        }
        
        sender.reloadInputViews()
    }
    
    private func showAddSubjectAlert() {
        let alertController = UIAlertController(title: "Add Subject", message: "Enter subject name:", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Subject name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if let subjectName = alertController.textFields?.first?.text, !subjectName.isEmpty {
                self.viewModel.addSubject(name: subjectName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ScheduleCreationViewController: ScheduleCreationDelegate {
    func saveSchedule() {
        self.viewModel.addSchedule()
        self.dismiss(animated: true)
    }
}

extension ScheduleCreationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return self.viewModel.subjectsNames.isEmpty ? 1 : 2
            case 1:
                return 1
            case 2:
                return 2
            default:
                break
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            cell.textLabel?.text = self.viewModel.subjectsNames.isEmpty ?  "Add Subject" : (row == 0 ? "Add Subject" : self.viewModel.selectedSubjectName)
            let systemName = self.viewModel.subjectsNames.isEmpty ? "plus" : (row == 0 ? "plus" : "chevron.down")
            cell.accessoryView = UIImageView(image: UIImage(systemName: systemName))
        } else if section == 1 {
            cell.textLabel?.text = self.viewModel.selectedDay
            cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.down"))
        } else if section == 2 {
            cell.textLabel?.text = row == 0 ? "Start" : "End"
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            datePicker.tag = row
            cell.accessoryView = datePicker
        }
        
        if self.traitCollection.userInterfaceStyle == .light {
            cell.backgroundColor = .systemGray5
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Subject"
        } else if section == 1 {
            return "Day"
        }
        
        return "Timer"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if self.viewModel.subjectsNames.isEmpty {
                self.showAddSubjectAlert()
            } else {
                if row == 0 {
                    self.showAddSubjectAlert()
                } else {
                    if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                        self.present(popover, animated: true)
                    }
                }
            }
        } else if section == 1 {
            if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                self.present(popover, animated: true)
            }
        }
    }
}

extension ScheduleCreationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
            case 0:
                return self.viewModel.subjectsNames.count
            case 1:
                return self.viewModel.days.count
            default:
                break
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
            case 0:
                return self.viewModel.subjectsNames[row]
            case 1:
                return self.viewModel.days[row]
            default:
                break
        }
        
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tableRow = pickerView.tag == 0 ? 1 : 0
        let cell = self.scheduleCreationView.tableView.cellForRow(at: IndexPath(row: tableRow, section: pickerView.tag))
        
        switch pickerView.tag {
            case 0:
                self.viewModel.selectedSubjectName = self.viewModel.subjectsNames[row]
                cell?.textLabel?.text = self.viewModel.selectedSubjectName
            case 1:
                self.viewModel.selectedDay = self.viewModel.days[row]
                cell?.textLabel?.text = self.viewModel.selectedDay
            default:
                break
        }
    }
}

// MARK: - Popover Creation
extension ScheduleCreationViewController {
    func createDayPopover(forTableView tableView: UITableView, at indexPath: IndexPath) -> Popover? {
        guard let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        let section = indexPath.section
        
        let popoverVC = Popover(contentSize: CGSize(width: 200, height: 150))
        let sourceRect = CGRect(x: cell.bounds.midX,
                                y: cell.bounds.midY,
                                width: 0,
                                height: 0)
        popoverVC.setPresentationVC(sourceView: cell, permittedArrowDirections: .up, sourceRect: sourceRect, delegate: self)
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self
        dayPicker.dataSource = self
        dayPicker.tag = section
        
        popoverVC.view = dayPicker
        
        let items = section == 0 ? self.viewModel.days : self.viewModel.subjectsNames
        let selectedItem = section == 0 ? self.viewModel.selectedDay : self.viewModel.selectedSubjectName
        
        if let selectedIndex = items.firstIndex(where: { $0 == selectedItem }) {
            dayPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }
        
        return popoverVC
    }
}

// MARK: - Popover Delegate
extension ScheduleCreationViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

#Preview {
    ScheduleCreationViewController()
}
