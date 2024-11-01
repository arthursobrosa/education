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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(getter: UIView.tintColor)) {
            /// store cell's bounds
            let bounds = cell.bounds
            
            /// cell initial config
            let cornerRadius: CGFloat = bounds.width * (15 / 353)
            let borderWidth: CGFloat = 1.5
            cell.backgroundColor = .systemBackground
            cell.selectionStyle = .none

            /// layer and path initialization for border
            let layer = CAShapeLayer()
            let path = CGMutablePath()

            /// depending on the row, a line will drawn or not
            var addLine = false
            
            /// if current row is the first and section only has one row
            if indexPath.row == 0 && tableView.numberOfRows(inSection: indexPath.section) == 1 {
                /// then add a rounded rectangle around its bounds
                cell.roundCorners(corners: .allCorners, radius: cornerRadius * 0.95, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)

            /// if it's the first row but section has more than one row
            } else if indexPath.row == 0 {
                /// then create an arc at the top
                cell.createCurve(on: .top, radius: cornerRadius, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)
                
                /// and a line will need to be created below this row
                addLine = true

            /// if it's the last row of a section with more than one row
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                /// then create an arc at the bottom
                cell.createCurve(on: .bottom, radius: cornerRadius, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)

            /// if it's an inbetween row
            } else {
                /// then create two lines at the sides
                cell.createCurve(on: .laterals, borderWidth: borderWidth, borderColor: UIColor.buttonNormal)
                
                /// and a line will also need to be created below this row
                addLine = true
            }

            /// create separator line for the rows that need to
            if addLine {
                let lineHeight: CGFloat = 1 / UIScreen.main.scale
                let offset = bounds.width / 21.53 /// little offset to imitate native line separator style
                layer.frame = CGRect(x: bounds.minX + offset, y: bounds.height - lineHeight, width: bounds.width - offset, height: lineHeight)
                layer.backgroundColor = tableView.separatorColor?.cgColor
                
                /// guarantee separator layer colors are updated correctly both at light and dark mode
                registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
                    layer.backgroundColor = tableView.separatorColor?.cgColor
                }
            }

            /// create UIView with the same size of the cell and the created layers to it
            let backgroundView = UIView(frame: bounds)
            backgroundView.layer.insertSublayer(layer, at: 0)
            backgroundView.backgroundColor = .clear

            /// set new background view as cell's background view
            cell.backgroundView = backgroundView
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            3
        case 1:
            1
        case 2:
            2
        case 3:
            1
        default:
            0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultCell.identifier, for: indexPath)

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
