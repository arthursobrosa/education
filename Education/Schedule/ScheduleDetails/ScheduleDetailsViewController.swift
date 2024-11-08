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
            let numberOfSections = scheduleDetailsView.tableView.numberOfSections
            let numberOfDaySections = numberOfSections - 3
            
            let isEnabled = !isPopoverOpen
            
            for section in 1...numberOfDaySections {
                let indexPath = IndexPath(row: 0, section: section)
                
                if let dateCell = scheduleDetailsView.tableView.cellForRow(at: indexPath) as? DateCell {
                    dateCell.startDatePicker.isEnabled = isEnabled
                    dateCell.endDatePicker.isEnabled = isEnabled
                }
            }
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
        view.tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.identifier)

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

    func showInvalidDatesAlert() {
        let message = String(localized: "invalidDateAlertMessage")

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
    
    @objc
    private func dayMinustButtonTapped() {
        viewModel.deleteLastDaySection()
        reloadTable()
        scheduleDetailsView.setupUI()
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension ScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfSections = tableView.numberOfSections
        
        let section = indexPath.section
        guard section == 0 || section == numberOfSections - 1 || section == numberOfSections - 2 else { return }
        
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
        let numberOfSections = tableView.numberOfSections
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numberOfSections = tableView.numberOfSections
        let section = indexPath.section
        
        if section == 0 || section == numberOfSections - 1 || section == numberOfSections - 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BorderedTableCell.identifier, for: indexPath) as? BorderedTableCell else {
                fatalError("Could not dequeue bordered table cell")
            }

            cell.textLabel?.text = createCellTitle(for: indexPath, numberOfSections: numberOfSections)
            cell.textLabel?.font = UIFont(name: Fonts.darkModeOnMedium, size: 16)
            cell.accessoryView = createAccessoryView(for: indexPath, numberOfSections: numberOfSections)

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.identifier, for: indexPath) as? DateCell else {
                fatalError("Could not dequeue date cell")
            }
            
            cell.delegate = self
            cell.selectionStyle = .none
            cell.section = section
            cell.dayOfWeekTitle = viewModel.getDayOfWeekText(forSection: section)
            
            if let selectedDate = viewModel.getSelectedDate(forSection: section) {
                let datePickerTag = viewModel.getDatePickerTag(forRowAt: indexPath)
                
                cell.startDatePicker.date = selectedDate.startTime
                cell.startDatePicker.tag = datePickerTag
                
                cell.endDatePicker.date = selectedDate.endTime
                cell.endDatePicker.tag = datePickerTag + 1
            }
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
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
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let numberOfSections = tableView.numberOfSections
        
        if section == 0 || section == numberOfSections - 1 || section == numberOfSections - 2 {
            return 50
        }
        
        return 150
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let isUpdating = viewModel.isUpdatingSchedule()
        let numberOfSections = tableView.numberOfSections
        let numberOfDaySections = tableView.numberOfSections - 3
        
        // Last day section
        if !isUpdating && section == numberOfSections - 3 {
            let footerView = UIView()
            
            if numberOfDaySections == 1 {
                let plusCircleView = getCircleView(isPlus: true, atTableView: tableView)
                
                footerView.addSubview(plusCircleView)
                
                NSLayoutConstraint.activate([
                    plusCircleView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
                    plusCircleView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                ])
            } else if numberOfDaySections == 7 {
                let minusCircleView = getCircleView(isPlus: false, atTableView: tableView)
                
                footerView.addSubview(minusCircleView)
                
                NSLayoutConstraint.activate([
                    minusCircleView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
                    minusCircleView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
                ])
            } else {
                let plusCircleView = getCircleView(isPlus: true, atTableView: tableView)
                let minusCircleView = getCircleView(isPlus: false, atTableView: tableView)
                
                footerView.addSubview(plusCircleView)
                footerView.addSubview(minusCircleView)
                
                NSLayoutConstraint.activate([
                    plusCircleView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
                    plusCircleView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: -16),
                    
                    minusCircleView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 4),
                    minusCircleView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor, constant: 16),
                ])
            }

            return footerView
        }
        
        // All other sections
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    private func getCircleView(isPlus: Bool, atTableView tableView: UITableView) -> UIView {
        let circleView = UIView()
        circleView.layer.cornerRadius = 12
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.buttonNormal.cgColor
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (_: Self, _: UITraitCollection) in
            circleView.layer.borderColor = UIColor.buttonNormal.cgColor
        }
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemText80
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        var imageName: String
        var selector: Selector
        
        if isPlus {
            imageName = "plus"
            selector = #selector(dayPlusButtonTapped)
        } else {
            imageName = "minus"
            selector = #selector(dayMinustButtonTapped)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        circleView.addGestureRecognizer(tapGesture)
        
        let image = UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15))
        imageView.image = image
        
        circleView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: tableView.bounds.width * (23 / 366)),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor),
            
            imageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 15 / 23),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
        ])
        
        return circleView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let isUpdating = viewModel.isUpdatingSchedule()
        let numberOfSections = tableView.numberOfSections
        
        if !isUpdating && section == numberOfSections - 3 {
            return 42
        } else {
            return 15
        }
    }
}
