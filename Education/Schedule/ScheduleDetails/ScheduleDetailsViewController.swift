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
    
    var isPopoverOpen: Bool = false {
        didSet {
            guard let startTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
                  let endTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
                  let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
                  let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else {
                
                return
            }

            let isEnabled = !isPopoverOpen

            startDatePicker.isEnabled = isEnabled
            endDatePicker.isEnabled = isEnabled
        }
    }

    // MARK: - UI Properties

    lazy var scheduleDetailsView: ScheduleDetailsView = {
        let view = ScheduleDetailsView()

        view.delegate = self
        view.subjectDelegate = self
        view.popoverDelegate = self

        view.tableView.delegate = self
        view.tableView.dataSource = self

        return view
    }()

    // MARK: - Initializer

    init(viewModel: ScheduleDetailsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = scheduleDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItems()

        if viewModel.schedule == nil {
            scheduleDetailsView.hideDeleteButton()
        }
        
        viewModel.selectedSubjectColor.bind { [weak self] _ in
            guard let self else { return }

            self.scheduleDetailsView.reloadSubjectTable()
        }
    }

    // MARK: - Methods

    private func setNavigationItems() {
        navigationItem.title = viewModel.getTitleName()

        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Fonts.darkModeOnSemiBold, size: 14) ?? .systemFont(ofSize: 14, weight: .semibold)]

        let cancelButton = UIButton(configuration: .plain())
        let regularFont = UIFont(name: Fonts.darkModeOnRegular, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let cancelAttributedString = NSAttributedString(string: String(localized: "cancel"), attributes: [.font: regularFont, .foregroundColor: UIColor.secondaryLabel])
        cancelButton.setAttributedTitle(cancelAttributedString, for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        let cancelItem = UIBarButtonItem(customView: cancelButton)

        navigationItem.leftBarButtonItems = [cancelItem]
    }

    @objc 
    private func didTapCancelButton() {
        coordinator?.dismiss(animated: true)
    }

    @objc 
    func datePickerChanged(_ sender: UIDatePicker) {
        switch sender.tag {
        case 1:
            viewModel.selectedStartTime = sender.date

            if viewModel.selectedEndTime <= viewModel.selectedStartTime {
                viewModel.selectedEndTime = viewModel.selectedStartTime.addingTimeInterval(60)
            }
        case 2:
            viewModel.selectedEndTime = sender.date

            if viewModel.selectedStartTime >= viewModel.selectedEndTime {
                viewModel.selectedStartTime = viewModel.selectedEndTime.addingTimeInterval(-60)
            }
        default:
            break
        }
    }

    @objc 
    func datePickerEditionBegan(_ sender: UIDatePicker) {
        guard let startTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
              let endTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
              let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
              let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else { return }

        endDatePicker.minimumDate = viewModel.selectedStartTime.addingTimeInterval(60)

        startDatePicker.isEnabled = sender.tag == 1
        endDatePicker.isEnabled = sender.tag == 2
    }

    @objc 
    func datePickerEditionEnded() {
        guard let startTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
              let endTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
              let startDatePicker = startTimeCell.accessoryView as? UIDatePicker,
              let endDatePicker = endTimeCell.accessoryView as? UIDatePicker else { return }

        startDatePicker.isEnabled = true
        endDatePicker.isEnabled = true

        startDatePicker.date = viewModel.selectedStartTime
        endDatePicker.date = viewModel.selectedEndTime
    }

    func showInvalidDatesAlert(forExistingSchedule: Bool) {
        var message: String
        
        if forExistingSchedule {
            message = String(format: NSLocalizedString("invalidDateAlertMessage1", comment: ""), viewModel.selectedDay.lowercased())
        } else {
            message = String(localized: "invalidDateAlertMessage2")
        }

        let alertController = UIAlertController(title: String(localized: "invalidDateAlertTitle"), message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .cancel)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

    func showNoSubjectAlert() {
        let alertController = UIAlertController(title: String(localized: "noSubjectAlertTitle"), message: String(localized: "noSubjectAlertMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .cancel)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BorderedTableCell else { return }
        cell.configureCell(tableView: tableView, forRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            1
        case 1:
            3
        case 2:
            2
        case 3:
            1
        default:
            0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTableCell.identifier, for: indexPath) as? BorderedTableCell else {
            fatalError("Could not dequeue bordered table cell")
        }

        cell.textLabel?.text = createCellTitle(for: indexPath)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.accessoryView = createAccessoryView(for: indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        switch section {
        case 0:
            if viewModel.selectedSubjectName.isEmpty {
                scheduleDetailsView.changeSubjectCreationView(isShowing: true)
                return
            }
                
            if let popover = createSubjectPopover(forTableView: tableView, at: indexPath) {
                isPopoverOpen.toggle()
                present(popover, animated: true)
            }
        case 1:
            if row == 0 {
                if let popover = createDayPopover(forTableView: tableView, at: indexPath) {
                    isPopoverOpen.toggle()
                    present(popover, animated: true)
                }
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        11
    }
}
