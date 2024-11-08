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
        let title = viewModel.getTitleName()
        scheduleDetailsView.setTitle(title)
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            scheduleDetailsView.tableView.reloadData()
        }
    }

    @objc 
    private func didTapCancelButton() {
        coordinator?.dismiss(animated: true)
    }
    
    private func getSelectedDayIndex(forDatePickerTag tag: Int) -> Int {
        let numberOfDaySections = numberOfSections(in: scheduleDetailsView.tableView) - 3
        
        var pairsArray: [[Int]] = []
        
        for pairIndex in 0..<numberOfDaySections {
            let baseIndex = pairIndex * 2
            let pair: [Int] = [baseIndex + 1, baseIndex + 2]
            pairsArray.append(pair)
        }
        
        for (index, pair) in pairsArray.enumerated() where pair.contains(tag) {
            return index
        }
        
        return 0
    }
    
    private func updateStartAndEndTime(tag: Int, date: Date) {
        let isUpdating = viewModel.isUpdatingSchedule()
        
        if isUpdating {
            switch tag {
            case 1:
                viewModel.selectedStartTime = date

                if viewModel.selectedEndTime <= viewModel.selectedStartTime {
                    viewModel.selectedEndTime = viewModel.selectedStartTime.addingTimeInterval(60)
                }
            case 2:
                viewModel.selectedEndTime = date

                if viewModel.selectedStartTime >= viewModel.selectedEndTime {
                    viewModel.selectedStartTime = viewModel.selectedEndTime.addingTimeInterval(-60)
                }
            default:
                break
            }
        } else {
            let selectedDayIndex = getSelectedDayIndex(forDatePickerTag: tag)
            
            let startTime = viewModel.selectedDays[selectedDayIndex].startTime
            let endTime = viewModel.selectedDays[selectedDayIndex].endTime
            
            if !tag.isMultiple(of: 2) {
                viewModel.selectedDays[selectedDayIndex].startTime = date
                let newStartTime = viewModel.selectedDays[selectedDayIndex].startTime
                
                if endTime <= newStartTime {
                    viewModel.selectedDays[selectedDayIndex].endTime = date.addingTimeInterval(60)
                }
            } else {
                viewModel.selectedDays[selectedDayIndex].endTime = date
                let newEndTime = viewModel.selectedDays[selectedDayIndex].endTime
                
                if startTime >= newEndTime {
                    viewModel.selectedDays[selectedDayIndex].startTime = date.addingTimeInterval(-60)
                }
            }
        }
    }
    
    private func getDatePickers(forDatePickerTag tag: Int) -> (start: FakeDatePicker, end: FakeDatePicker)? {
        let isUpdating = viewModel.isUpdatingSchedule()
        var startTimeIndexPath = IndexPath(row: 1, section: 1)
        var endTimeIndexPath = IndexPath(row: 2, section: 1)
        
        if !isUpdating {
            let section = getSelectedDayIndex(forDatePickerTag: tag) + 1
            startTimeIndexPath = IndexPath(row: 1, section: section)
            endTimeIndexPath = IndexPath(row: 2, section: section)
        }
        
        guard let startTimeCell = scheduleDetailsView.tableView.cellForRow(at: startTimeIndexPath),
              let endTimeCell = scheduleDetailsView.tableView.cellForRow(at: endTimeIndexPath),
              let startDatePicker = startTimeCell.accessoryView as? FakeDatePicker,
              let endDatePicker = endTimeCell.accessoryView as? FakeDatePicker else {
            
            return nil
        }
        
        return (startDatePicker, endDatePicker)
    }
    
    private func getSelectedTime(forDatePickerTag tag: Int, isStartTime: Bool) -> Date? {
        let isUpdating = viewModel.isUpdatingSchedule()
        var startTime = Date()
        var endTime = Date()
        
        if isUpdating {
            startTime = viewModel.selectedStartTime
            endTime = viewModel.selectedEndTime
        } else {
            let selectedDayIndex = getSelectedDayIndex(forDatePickerTag: tag)
            startTime = viewModel.selectedDays[selectedDayIndex].startTime
            endTime = viewModel.selectedDays[selectedDayIndex].endTime
        }
        
        return isStartTime ? startTime : endTime
    }
    
    private func getMinimumDate(forDatePickerTag tag: Int) -> Date? {
        let startTime = getSelectedTime(forDatePickerTag: tag, isStartTime: true)
        return startTime?.addingTimeInterval(60)
    }

    @objc 
    func datePickerEditionBegan(_ sender: FakeDatePicker) {
        guard let datePickers = getDatePickers(forDatePickerTag: sender.tag) else { return }
        
        let startDatePicker = datePickers.start
        let endDatePicker = datePickers.end

        endDatePicker.minimumDate = getMinimumDate(forDatePickerTag: sender.tag)

        startDatePicker.isEnabled = !sender.tag.isMultiple(of: 2)
        endDatePicker.isEnabled = sender.tag.isMultiple(of: 2)
    }

    @objc 
    func datePickerEditionEnded(_ sender: FakeDatePicker) {
        updateStartAndEndTime(tag: sender.tag, date: sender.date)
        
        guard let datePickers = getDatePickers(forDatePickerTag: sender.tag) else { return }
        
        let startDatePicker = datePickers.start
        let endDatePicker = datePickers.end

        startDatePicker.isEnabled = true
        endDatePicker.isEnabled = true
        
        guard let startTime = getSelectedTime(forDatePickerTag: sender.tag, isStartTime: true),
              let endtime = getSelectedTime(forDatePickerTag: sender.tag, isStartTime: false) else {
            
            return
        }

        startDatePicker.date = startTime
        endDatePicker.date = endtime
    }

    func showInvalidDatesAlert(forExistingSchedule: Bool) {
        var message: String
        
        if forExistingSchedule {
            message = String(localized: "invalidDateAlertMessage1")
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
    
    @objc
    private func dayPlusButtonTapped() {
        viewModel.createNewDaySection()
        reloadTable()
        scheduleDetailsView.setupUI()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? BorderedTableCell else { return }
        cell.configureCell(tableView: tableView, forRowAt: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let isUpdating = viewModel.isUpdatingSchedule()
            
        if isUpdating {
            return 4
        } else {
            return 3 + viewModel.selectedDays.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isUpdating = viewModel.isUpdatingSchedule()
        var numberOfSections = 0
        
        if isUpdating {
            numberOfSections = 4
        } else {
            numberOfSections = 3 + viewModel.selectedDays.count
        }
        
        // Subject section
        if section == 0 {
            return 1
        }
        
        // Alarm section
        if section == numberOfSections - 2 {
            return 2
        }
        
        // App Blocking section
        if section == numberOfSections - 1 {
            return 1
        }
        
        // Day section
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTableCell.identifier, for: indexPath) as? BorderedTableCell else {
            fatalError("Could not dequeue bordered table cell")
        }
        
        let isUpdating = viewModel.isUpdatingSchedule()
        var numberOfSections = 0
        
        if isUpdating {
            numberOfSections = 4
        } else {
            numberOfSections = 3 + viewModel.selectedDays.count
        }

        cell.textLabel?.text = createCellTitle(for: indexPath, numberOfSections: numberOfSections)
        cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
        cell.accessoryView = createAccessoryView(for: indexPath, numberOfSections: numberOfSections)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let isUpdating = viewModel.isUpdatingSchedule()
        var numberOfSections = 0
        
        if isUpdating {
            numberOfSections = 4
        } else {
            numberOfSections = 3 + viewModel.selectedDays.count
        }
        
        // Subjects section
        if section == 0 {
            if viewModel.selectedSubjectName.isEmpty {
                scheduleDetailsView.changeSubjectCreationView(isShowing: true)
                return
            }
                
            if let popover = createSubjectPopover(forTableView: tableView, at: indexPath) {
                isPopoverOpen.toggle()
                present(popover, animated: true)
            }
        } else if section != numberOfSections - 1 && section != numberOfSections - 2 { // Day section
            if row == 0 {
                if let popover = createDayPopover(forTableView: tableView, at: indexPath) {
                    isPopoverOpen.toggle()
                    present(popover, animated: true)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let isUpdating = viewModel.isUpdatingSchedule()
        var numberOfSections = 0
        
        if isUpdating {
            numberOfSections = 4
        } else {
            numberOfSections = 3 + viewModel.selectedDays.count
        }
        
        // Last day section
        if !isUpdating && section == numberOfSections - 3 {
            let footerView = UIView()
            
            let circleView = UIView()
            circleView.layer.cornerRadius = 12
            circleView.layer.borderWidth = 1
            circleView.layer.borderColor = UIColor.buttonNormal.cgColor
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayPlusButtonTapped))
            circleView.addGestureRecognizer(tapGesture)
            
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
                circleView.layer.borderColor = UIColor.buttonNormal.cgColor
            }
            
            circleView.translatesAutoresizingMaskIntoConstraints = false
            
            let plusImageView = UIImageView()
            let plusImage = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15))
            plusImageView.contentMode = .scaleAspectFit
            plusImageView.tintColor = UIColor.systemText80
            plusImageView.image = plusImage
            plusImageView.translatesAutoresizingMaskIntoConstraints = false
            
            footerView.addSubview(circleView)
            circleView.addSubview(plusImageView)
            
            NSLayoutConstraint.activate([
                circleView.widthAnchor.constraint(equalToConstant: tableView.bounds.width * (23 / 366)),
                circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
                circleView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
                circleView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                
                plusImageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 15 / 23),
                plusImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
                plusImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            ])
            
            return footerView
        }
        
        // All other sections
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let isUpdating = viewModel.isUpdatingSchedule()
        var numberOfSections = 0
        
        if isUpdating {
            numberOfSections = 4
        } else {
            numberOfSections = 3 + viewModel.selectedDays.count
        }
        
        if !isUpdating && section == numberOfSections - 3 {
            return 42
        } else {
            return 15
        }
    }
}
