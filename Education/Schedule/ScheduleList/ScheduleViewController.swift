//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import TipKit
import UIKit

class ScheduleViewController: UIViewController {
    // MARK: - Coordinator and ViewModel

    weak var coordinator: (ShowingScheduleDetails & ShowingFocusImediate & ShowingScheduleNotification & ShowingScheduleDetailsModal & ShowingFocusSelection & ShowingSubjectCreation)?
    let viewModel: ScheduleViewModel

    var createActivityTip = CreateActivityTip()

    // MARK: - Properties

    lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()

        view.delegate = self

        view.dailyScheduleView.tableView.dataSource = self
        view.dailyScheduleView.tableView.delegate = self
        view.dailyScheduleView.tableView.register(DailyScheduleCell.self, forCellReuseIdentifier: DailyScheduleCell.identifier)

        view.weeklyScheduleCollection.dataSource = self
        view.weeklyScheduleCollection.delegate = self
        view.weeklyScheduleCollection.register(DayColumnCell.self, forCellWithReuseIdentifier: DayColumnCell.identifier)

        return view
    }()

    // MARK: - Initializer

    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = scheduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setNavigationItems()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, traitCollection: UITraitCollection) in
            self.loadSchedules()
            
            if traitCollection.userInterfaceStyle == .light {
                self.scheduleView.scheduleModeSelector.segmentImage = UIImage(color: UIColor.systemBackground)
            } else {
                self.scheduleView.scheduleModeSelector.segmentImage = UIImage(color: UIColor.systemBackground)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.selectedWeekday = Calendar.current.component(.weekday, from: Date()) - 1
        loadSchedules()
        setDaysStack(scheduleView.dailyScheduleView.daysStack)
    }

    // MARK: - Methods
    
    private func setNavigationItems() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        scheduleView.setNavigationBar()
    }

    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func viewTapped() {
        dismissButtons()
    }

    private func reloadCollections() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.scheduleView.weeklyScheduleCollection.reloadData()
        }
    }
    
    private func reloadTables() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.scheduleView.dailyScheduleView.tableView.reloadData()
        }
    }

    func unselectDays() {
        let dayViews = scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }

        for dayView in dayViews {
            if let dayOfWeek = dayView.dayOfWeek {
                dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, isSelected: false, isToday: dayOfWeek.isToday)
            }
        }
    }

    func selectToday() {
        let dayViews = scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }

        for dayView in dayViews {
            if let dayOfWeek = dayView.dayOfWeek {
                if dayOfWeek.isToday {
                    dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, isSelected: true, isToday: dayOfWeek.isToday)
                    viewModel.selectedDate = viewModel.daysOfWeek[dayView.tag]
                }
            }
        }
    }

    func loadSchedules() {
        viewModel.fetchSchedules()
        setContentView()
        reloadTables()
        reloadCollections()
    }

    func dismissButtons() {
        view.gestureRecognizers = nil
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.scheduleView.createAcitivityButton.alpha = 0
            self.scheduleView.startActivityButton.alpha = 0
        }
    }
}

// MARK: - Sheet Delegate

extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed _: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        loadSchedules()

        return nil
    }
}

// MARK: - UI Setup

extension ScheduleViewController {
    func setContentView() {
        for subview in scheduleView.dailyScheduleView.contentView.subviews {
            subview.removeFromSuperview()
        }

        for subview in scheduleView.contentView.subviews {
            subview.removeFromSuperview()
        }

        let contentViewInfo = viewModel.getContentViewInfo()
        let isDaily = contentViewInfo.isDaily
        let isEmpty = contentViewInfo.isEmpty

        if isEmpty {
            scheduleView.setNoSchedulesView(isDaily: isDaily)
            handleTip()

            addContentSubview(parentSubview: scheduleView.dailyScheduleView.contentView, childSubview: scheduleView.noSchedulesView)
            addContentSubview(parentSubview: scheduleView.contentView, childSubview: scheduleView.dailyScheduleView)
        } else {
            if isDaily {
                addContentSubview(parentSubview: scheduleView.dailyScheduleView.contentView, childSubview: scheduleView.dailyScheduleView.tableView)
                addContentSubview(parentSubview: scheduleView.contentView, childSubview: scheduleView.dailyScheduleView)
            } else {
                addContentSubview(parentSubview: scheduleView.contentView, childSubview: scheduleView.weeklyScheduleCollection)
            }
        }
    }

    private func addContentSubview(parentSubview: UIView, childSubview: UIView) {
        parentSubview.addSubview(childSubview)

        childSubview.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            childSubview.topAnchor.constraint(equalTo: parentSubview.topAnchor),
            childSubview.leadingAnchor.constraint(equalTo: parentSubview.leadingAnchor),
            childSubview.trailingAnchor.constraint(equalTo: parentSubview.trailingAnchor),
            childSubview.bottomAnchor.constraint(equalTo: parentSubview.bottomAnchor),
        ])
    }

    private func handleTip() {
        Task { @MainActor in
            for await shouldDisplay in createActivityTip.shouldDisplayUpdates {
                if shouldDisplay {
                    if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
                        let controller = TipUIPopoverViewController(createActivityTip, sourceItem: rightBarButtonItem)
                        controller.view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)

                        present(controller, animated: true)
                    }
                } else if presentedViewController is TipUIPopoverViewController {
                    dismiss(animated: true)
                }
            }
        }
    }
}
