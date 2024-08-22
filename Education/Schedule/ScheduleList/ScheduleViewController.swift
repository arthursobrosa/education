//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingScheduleDetails & ShowingFocusImediate & ShowingScheduleNotification & ShowingScheduleDetailsModal & ShowingFocusSelection)?
    let viewModel: ScheduleViewModel
    
    // MARK: - Properties
    lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()
        
        view.delegate = self
        
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.identifier)
        view.collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        
        return view
    }()
    
    // MARK: - Initializer
    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        
        self.view = self.scheduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        let addScheduleButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addScheduleButtonTapped))
        self.navigationItem.rightBarButtonItems = [addScheduleButton]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.scheduleView.overlayView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadSchedules()
    }
    
    // MARK: - Methods
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.scheduleView.tableView.reloadData()
        }
    }
    
    func reloadCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.scheduleView.collectionView.reloadData()
        }
    }
    
    func unselectDays() {
        let dayViews = self.scheduleView.picker.arrangedSubviews.compactMap { $0 as? DayView }
        
        dayViews.forEach { dayView in
            if let dayOfWeek = dayView.dayOfWeek {
                dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: false, isToday: dayOfWeek.isToday)
            }
        }
    }
    
    func selectToday() {
        let dayViews = self.scheduleView.picker.arrangedSubviews.compactMap { $0 as? DayView }
        
        dayViews.forEach { dayView in
            if let dayOfWeek = dayView.dayOfWeek {
                if dayOfWeek.isToday {
                    dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
                    self.viewModel.selectedDay = dayView.tag
                }
            }
        }
    }
    
    @objc private func addScheduleButtonTapped() {
        let newAlpha: CGFloat = self.scheduleView.overlayView.alpha == 0 ? 1 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.scheduleView.overlayView.alpha = newAlpha
            self.scheduleView.createAcitivityButton.alpha = newAlpha
            self.scheduleView.startActivityButton.alpha = newAlpha
        }
    }
    
    func loadSchedules() {
        self.viewModel.fetchSchedules()
        
        self.setContentView()
        
        self.reloadTable()
        self.reloadCollection()
    }
    
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        self.dismissButtons()
    }
    
    func dismissButtons() {
        if self.scheduleView.overlayView.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.scheduleView.overlayView.alpha = 0
                self.scheduleView.createAcitivityButton.alpha = 0
                self.scheduleView.startActivityButton.alpha = 0
            }
        }
    }
    
    func showNoSubjectAlert() {
        let alertController = UIAlertController(title: String(localized: "noSubjectTitle"), message: String(localized: "noSubjectMessage"), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        let color = subject?.unwrappedColor
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else { fatalError("Could not dequeue cell") }
        
        cell.color = UIColor(named: color ?? "sealBackgroundColor")
        cell.delegate = self
        cell.subject = subject
        cell.schedule = schedule
        cell.indexPath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        
        self.coordinator?.showScheduleDetailsModal(schedule: schedule)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let schedule = self.viewModel.schedules[indexPath.row]
        
        if editingStyle == .delete {
            NotificationService.shared.cancelNotifications(forDate: schedule.startTime!)
            
            self.viewModel.removeSchedule(schedule)
            
            self.loadSchedules()
        }
    }
}

// MARK: - Sheet Delegate
extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.loadSchedules()
        
        return nil
    }
}

// MARK: - UI Setup
extension ScheduleViewController {
    private func setContentView() {
        self.scheduleView.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        var isDaily = false
        var isEmpty = false
        
        if self.viewModel.selectedViewMode == .daily {
            isEmpty = self.viewModel.schedules.isEmpty
            isDaily = true
        } else {
            let numberOfTaks = self.viewModel.tasks.count
            var emptyTasks = 0
            
            for task in self.viewModel.tasks {
                if task.isEmpty {
                    emptyTasks += 1
                }
            }
            
            isEmpty = emptyTasks == numberOfTaks
            
            isDaily = false
        }
        
        if isEmpty {
            self.scheduleView.changeEmptyView(isDaily: isDaily)
            self.addContentSubview(self.scheduleView.emptyView)
        } else {
            if isDaily {
                self.addContentSubview(self.scheduleView.tableView)
            } else {
                self.addContentSubview(self.scheduleView.collectionView)
            }
        }
    }
    
    private func addContentSubview(_ subview: UIView) {
        self.scheduleView.contentView.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: self.scheduleView.contentView.topAnchor),
            subview.leadingAnchor.constraint(equalTo: self.scheduleView.contentView.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: self.scheduleView.contentView.trailingAnchor),
            subview.bottomAnchor.constraint(equalTo: self.scheduleView.contentView.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(viewModel.tasks[section].count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.tasks[indexPath.section].isEmpty {
            
            let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath) as! EmptyCell
            return emptyCell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
                return UICollectionViewCell()
            }
            
            let task = viewModel.tasks[indexPath.section][indexPath.item]
            
            let subject = self.viewModel.getSubject(fromSchedule: task)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let firstThreeLetters = self.viewModel.firstThreeLetters(of: subject?.unwrappedName ?? String())
            
            cell.configure(with: firstThreeLetters, startTime: formatter.string(from: task.unwrappedStartTime), endTime: formatter.string(from: task.unwrappedEndTime), bgColor: subject?.unwrappedColor ?? "")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !viewModel.tasks[indexPath.section].isEmpty {
            let task = viewModel.tasks[indexPath.section][indexPath.item]
            
            self.coordinator?.showScheduleDetails(schedule: task, selectedDay: indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width
        let numberOfSections = CGFloat(7)
        let itemWidth = (totalWidth - 29) / numberOfSections
        return CGSize(width: itemWidth, height: 67)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfSections = collectionView.numberOfSections
        let leftInset: CGFloat = section == 0 ? 2 : 2
        let rightInset: CGFloat = section == numberOfSections - 1 ? 0 : 2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 4, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
