//
//  ScheduleDetailsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleDetailsViewController: UIViewController {
    // MARK: - ViewModel
    let viewModel: ScheduleDetailsViewModel
    
    // MARK: - Properties
    lazy var scheduleDetailsView: ScheduleDetailsView = {
        let view = ScheduleDetailsView()
        
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        return view
    }()
    
    // MARK: - Initializer
    init(viewModel: ScheduleDetailsViewModel = ScheduleDetailsViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.scheduleDetailsView
    }
    
    // MARK: - Methods
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.scheduleDetailsView.tableView.reloadData()
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
            
            self.reloadTable()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        cell.textLabel?.text = self.createCellTitle(for: indexPath)
        cell.accessoryView = self.createAccessoryView(for: indexPath)
        
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
        
        switch section {
            case 0:
                if self.viewModel.subjectsNames.isEmpty {
                    self.showAddSubjectAlert()
                    break
                }
                
                if row == 0 {
                    self.showAddSubjectAlert()
                    break
                }
                
                if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                    self.present(popover, animated: true)
                }
            case 1:
                if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                    self.present(popover, animated: true)
                }
            default:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#Preview {
    ScheduleDetailsViewController()
}
