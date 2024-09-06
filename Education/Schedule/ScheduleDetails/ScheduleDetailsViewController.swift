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
        view.tableView.register(ScheduleDetailsCell.self, forCellReuseIdentifier: ScheduleDetailsCell.identifier)
        
        return view
    }()
    
    var isPopoverOpen: Bool = false {
        didSet {
            guard let startTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
                  let endTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
                  let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
                  let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else { return }
            
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
        
        self.setNavigationItems()
    }
    
    // MARK: - Methods
    private func setNavigationItems() {
        self.navigationItem.title = self.viewModel.getTitleName()
        
        guard let _ = self.viewModel.schedule else { return }
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(didTapDeleteButton))
        deleteButton.tintColor = UIColor(named: "FocusSettingsColor")
        
        self.navigationItem.rightBarButtonItems = [deleteButton]
    }
    
    @objc private func didTapDeleteButton() {
        let alertController = UIAlertController(title: "Schedule Deletion", message: "Are you sure you want to delete this schedule?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            guard let schedule = self.viewModel.schedule else { return }
            NotificationService.shared.cancelNotifications(forDate: schedule.unwrappedStartTime)
            self.viewModel.removeSchedule(schedule)
            self.coordinator?.dismiss(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true)
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        switch sender.tag {
            case 1:
                self.viewModel.selectedStartTime = sender.date
                
                if self.viewModel.selectedEndTime <= self.viewModel.selectedStartTime {
                    self.viewModel.selectedEndTime = self.viewModel.selectedStartTime.addingTimeInterval(60)
                }
            case 2:
                self.viewModel.selectedEndTime = sender.date
                
                if self.viewModel.selectedStartTime >= self.viewModel.selectedEndTime {
                    self.viewModel.selectedStartTime = self.viewModel.selectedEndTime.addingTimeInterval(-60)
                }
            default:
                break
        }
    }
    
    @objc func datePickerEditionBegan(_ sender: UIDatePicker) {
        guard let startTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
              let endTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
              let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
              let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else { return }
        
        startDatePicker.isEnabled = sender.tag == 1
        endDatePicker.isEnabled = sender.tag == 2
    }
    
    @objc func datePickerEditionEnded() {
        guard let startTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
              let endTimeCell = self.scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
              let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
              let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else { return }
        
        startDatePicker.isEnabled = true
        endDatePicker.isEnabled = true

        startDatePicker.date = self.viewModel.selectedStartTime
        endDatePicker.date = self.viewModel.selectedEndTime
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleDetailsCell.identifier, for: indexPath) as? ScheduleDetailsCell else {
            fatalError("Could not dequeue cell")
        }
        
        cell.textLabel?.text = self.createCellTitle(for: indexPath)
        cell.accessoryView = self.createAccessoryView(for: indexPath)
        
        cell.indexPath = indexPath
        
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
                if let popover = self.createSubjectPopover(forTableView: tableView, at: indexPath) {
                    self.isPopoverOpen.toggle()
                    self.present(popover, animated: true)
                }
            default:
                break
        }
    }
}
