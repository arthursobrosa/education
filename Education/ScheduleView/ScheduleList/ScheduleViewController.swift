//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: ShowingScheduleDetails?
    let viewModel: ScheduleViewModel
    
    // MARK: - Properties
    private lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()
        
        view.delegate = self
        
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        
        return view
    }()
    
    private let scheduleColors: [UIColor] = [.systemIndigo, .systemGreen, .systemOrange, .systemPurple]
    
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
        
        let addScheduleButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addScheduleButtonTapped))
        self.navigationItem.rightBarButtonItems = [addScheduleButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSchedules()
    }
    
    // MARK: - Methods
    func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.scheduleView.tableView.reloadData()
        }
    }
    
    func unselectDays() {
        let dayViews = self.scheduleView.picker.arrangedSubviews.compactMap { $0 as? DayView }
        
        dayViews.forEach { dayView in
            if let dayOfWeek = dayView.dayOfWeek {
                dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: false)
            }
        }
    }
    
    @objc private func addScheduleButtonTapped() {
        self.coordinator?.showScheduleDetails(schedule: nil, title: nil, selectedDay: self.viewModel.selectedDay)
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
        let color = self.scheduleColors[row % self.scheduleColors.count]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.identifier, for: indexPath) as? ScheduleTableViewCell else { fatalError("Could not dequeue cell") }
        
        cell.subject = subject
        cell.schedule = schedule
        cell.color = color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let schedule = self.viewModel.schedules[row]
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        let subjectName = subject?.unwrappedName
        
        self.coordinator?.showScheduleDetails(schedule: schedule, title: subjectName, selectedDay: self.viewModel.selectedDay)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let schedule = self.viewModel.schedules[indexPath.row]
        
        if editingStyle == .delete {
            self.viewModel.removeSchedule(schedule)
            self.viewModel.fetchSchedules()
            self.reloadTable()
        }
    }
}

// MARK: - Sheet Delegate
extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.viewModel.fetchSchedules()
        self.reloadTable()
        
        return nil
    }
}
