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

        return view
    }()

    var isPopoverOpen: Bool = false {
        didSet {
            guard let startTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
                  let endTimeCell = scheduleDetailsView.tableView.cellForRow(at: IndexPath(row: 2, section: 0)),
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
    func numberOfSections(in _: UITableView) -> Int {
        return 4
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 2:
            return 2
        case 1, 3:
            return 1
        default:
            break
        }

        return Int()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as? CustomTableCell else {
            fatalError("Could not dequeue cell")
        }

        cell.textLabel?.text = createCellTitle(for: indexPath)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.accessoryView = createAccessoryView(for: indexPath)

        cell.row = indexPath.row
        cell.numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        switch section {
        case 0:
            if row == 0 {
                if let popover = createDayPopover(forTableView: tableView, at: indexPath) {
                    isPopoverOpen.toggle()
                    present(popover, animated: true)
                }
            }
        case 1:
            if let popover = createSubjectPopover(forTableView: tableView, at: indexPath) {
                isPopoverOpen.toggle()
                present(popover, animated: true)
            }
        default:
            break
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 11
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 0
    }
}
