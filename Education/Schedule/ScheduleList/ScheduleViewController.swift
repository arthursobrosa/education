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
        setTapGesture()

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            self.loadSchedules()
        }

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
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
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addButton.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.addTarget(self, action: #selector(addScheduleButtonTapped), for: .touchUpInside)
        addButton.tintColor = UIColor(named: "system-text")

        let addItem = UIBarButtonItem(customView: addButton)

        navigationItem.rightBarButtonItems = [addItem]

        navigationItem.title = viewModel.getTitleString()
        let regularFont: UIFont = UIFont(name: Fonts.coconRegular, size: Fonts.titleSize) ?? UIFont.systemFont(ofSize: Fonts.titleSize, weight: .regular)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: regularFont, .foregroundColor: UIColor(named: "system-text") as Any]
    }

    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        scheduleView.overlayView.addGestureRecognizer(tapGesture)
    }

    @objc 
    private func viewTapped(_: UITapGestureRecognizer) {
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
                dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: false, isToday: dayOfWeek.isToday)
            }
        }
    }

    func selectToday() {
        let dayViews = scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }

        for dayView in dayViews {
            if let dayOfWeek = dayView.dayOfWeek {
                if dayOfWeek.isToday {
                    dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
                    viewModel.selectedDate = viewModel.daysOfWeek[dayView.tag]
                }
            }
        }
    }

    @objc 
    private func addScheduleButtonTapped() {
        let newAlpha: CGFloat = scheduleView.overlayView.alpha == 0 ? 1 : 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }

            self.scheduleView.overlayView.alpha = newAlpha
            self.scheduleView.fourDotsView.alpha = newAlpha
            self.scheduleView.createAcitivityButton.alpha = newAlpha
            self.scheduleView.startActivityButton.alpha = newAlpha
        }
    }

    func loadSchedules() {
        viewModel.fetchSchedules()
        setContentView()
        reloadTables()
        reloadCollections()
    }

    func dismissButtons() {
        if scheduleView.overlayView.alpha == 1 {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }

                self.scheduleView.overlayView.alpha = 0
                self.scheduleView.fourDotsView.alpha = 0
                self.scheduleView.createAcitivityButton.alpha = 0
                self.scheduleView.startActivityButton.alpha = 0
            }
        }
    }

    func showNoSubjectAlert() {
        let alertController = UIAlertController(title: String(localized: "noSubjectTitle"), message: String(localized: "noSubjectMessage"), preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
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
            var childSubview = UIView()

            let hasSubjects = viewModel.hasSubjects()

            if hasSubjects {
                scheduleView.setNoSchedulesView(isDaily: isDaily)
                handleTip()
                childSubview = scheduleView.noSchedulesView
            } else {
                childSubview = scheduleView.noSubjectsView
            }

            addContentSubview(parentSubview: scheduleView.dailyScheduleView.contentView, childSubview: childSubview)
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
