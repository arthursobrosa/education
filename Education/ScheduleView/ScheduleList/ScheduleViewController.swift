//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingScheduleDetails & ShowingFocusSelection)?
    let viewModel: ScheduleViewModel
    
    // MARK: - Properties
    lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()
        
        view.delegate = self
        
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.identifier)
        
        return view
    }()
    
    private let scheduleColors: [UIColor] = [UIColor(named: "ScheduleColor1")!, UIColor(named: "ScheduleColor2")!, UIColor(named: "ScheduleColor3")!, UIColor(named: "ScheduleColor4")!, UIColor(named: "ScheduleColor5")!, UIColor(named: "ScheduleColor6")!]
    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.scheduleView.overlayView.addGestureRecognizer(tapGesture)
        
        self.scheduleView.btnCreateActivity.addTarget(self, action: #selector(createActivityBtnTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadSchedules()
    }
    
    // MARK: - Methods
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.scheduleView.tableView.reloadData()
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
    
    @objc private func addScheduleButtonTapped() {
        let newAlpha: CGFloat = self.scheduleView.overlayView.alpha == 0 ? 1 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.scheduleView.overlayView.alpha = newAlpha
            self.scheduleView.btnCreateActivity.alpha = newAlpha
            self.scheduleView.btnStartActivity.alpha = newAlpha
        }
    }
    
    func loadSchedules() {
        self.viewModel.fetchSchedules()
        
        self.setContentView(isEmpty: self.viewModel.schedules.isEmpty)
        
        self.reloadTable()
    }
    
    @objc private func createActivityBtnTapped() {
        ActivityManager.shared.isShowingActivity = false
        
        dismissButtons()
        self.coordinator?.showScheduleDetails(schedule: nil, title: nil, selectedDay: self.viewModel.selectedDay)
    }
    
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        // Verifica se o toque foi fora dos botões e oculta a overlayView se necessário
        dismissButtons()
    }
    
    private func dismissButtons() {
        // Esconde a overlayView e os botões se eles estiverem visíveis
        if self.scheduleView.overlayView.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.scheduleView.overlayView.alpha = 0
                self.scheduleView.btnCreateActivity.alpha = 0
                self.scheduleView.btnStartActivity.alpha = 0
            }
        }
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
        
        cell.color = color
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
        let subject = self.viewModel.getSubject(fromSchedule: schedule)
        let subjectName = subject?.unwrappedName
        
        self.coordinator?.showScheduleDetails(schedule: schedule, title: subjectName, selectedDay: self.viewModel.selectedDay)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let schedule = self.viewModel.schedules[indexPath.row]
        
        if editingStyle == .delete {
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
    func setContentView(isEmpty: Bool) {
        self.scheduleView.removeConstraints(self.scheduleView.emptyView.constraints)
        self.scheduleView.removeConstraints(self.scheduleView.tableView.constraints)
        
        self.addContentSubview(isEmpty ? self.scheduleView.emptyView : self.scheduleView.tableView)
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
