//
//  ScheduleDetailsViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 10/07/24.
//

import UIKit

class ScheduleDetailsViewController: UIViewController {
    // MARK: - Coordinator & ViewModel
    weak var coordinator: Dismissing?
    let viewModel: ScheduleDetailsViewModel
    
    // MARK: - Properties
    lazy var scheduleDetailsView: ScheduleDetailsView = {
        let view = ScheduleDetailsView()
        
        view.delegate = self
        
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCell.identifier)
        
        return view
    }()
    
    var isPopoverOpen: Bool = false {
        didSet {
            guard let startTimerCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
                  let endTimerCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
                  let startDatePicker = startTimerCell.accessoryView as? UIDatePicker,
                  let endDatePicker = endTimerCell.accessoryView as? UIDatePicker else { return }
            
            let isEnabled = !isPopoverOpen
            
            startDatePicker.isEnabled = isEnabled
            endDatePicker.isEnabled = isEnabled
        }
    }
    
    // MARK: - Initializer
    init(viewModel: ScheduleDetailsViewModel) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.viewModel.getTitleName()
    }
    
    // MARK: - Methods
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.scheduleDetailsView.tableView.reloadData()
        }
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        switch sender.tag {
            case 1:
                self.viewModel.selectedStartTime = sender.date
            case 2:
                self.viewModel.selectedEndTime = sender.date
            default:
                break
        }
        
        sender.reloadInputViews()
    }
    
    private func showAddSubjectAlert() {
        let alertController = UIAlertController(title: String(localized: "addSubjectAlertTitle"), message: String(localized: "addSubjectAlertMessage"), preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = String(localized: "addSubjectAlertPlaceholder")
        }
        
        let addAction = UIAlertAction(title: String(localized: "add"), style: .default) { [weak self] _ in
            guard let self else { return }
            
            if let subjectName = alertController.textFields?.first?.text, !subjectName.isEmpty {
                self.viewModel.addSubject(name: subjectName)
            }
            
            self.reloadTable()
        }
        
        let cancelAction = UIAlertAction(title: String(localized: "cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showInvalidDatesAlert(forExistingSchedule: Bool) {
        let message = forExistingSchedule ? String(format: NSLocalizedString("invalidDateAlertMessage1", comment: ""), self.viewModel.selectedDay.lowercased()) : String(localized: "invalidDateAlertMessage2")
        
        let alertController = UIAlertController(title: String(localized: "invalidDateAlertTitle"), message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNoSubjectAlert() {
        let alertController = UIAlertController(title: String(localized: "noSubjectAlertTitle"), message: String(localized: "noSubjectAlertMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 3
            case 1:
                return 2
            case 2, 3:
                return 1
            default:
                break
        }
        
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)
        cell.textLabel?.text = self.createCellTitle(for: indexPath)
        cell.accessoryView = self.createAccessoryView(for: indexPath)
        
        cell.backgroundColor = .systemGray5
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
            case 0:
                if row == 0 {
                    if let popover = self.createDayPopover(forTableView: tableView, at: indexPath) {
                        self.isPopoverOpen.toggle()
                        self.present(popover, animated: true)
                    }
                }
            case 2:
                if self.viewModel.subjectsNames.isEmpty {
                    self.showAddSubjectAlert()
                    break
                }
                
                if let popover = self.createSubjectPopover(forTableView: tableView, at: indexPath) {
                    self.isPopoverOpen.toggle()
                    self.present(popover, animated: true)
                }
            default:
                break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
