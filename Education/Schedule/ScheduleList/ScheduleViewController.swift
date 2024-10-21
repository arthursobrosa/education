//
//  ScheduleViewController.swift
//  Education
//
//  Created by Arthur Sobrosa on 16/07/24.
//

import UIKit
import TipKit

class ScheduleViewController: UIViewController {
    // MARK: - Coordinator and ViewModel
    weak var coordinator: (ShowingScheduleDetails & ShowingFocusImediate & ShowingScheduleNotification & ShowingScheduleDetailsModal & ShowingFocusSelection & ShowingSubjectCreation)?
    let viewModel: ScheduleViewModel
    
    var createActivityTip = CreateActivityTip()
    
    // MARK: - Properties
    lazy var scheduleView: ScheduleView = {
        let view = ScheduleView()
        
        view.delegate = self
        
        view.dailyScheduleView.collectionView.dataSource = self
        view.dailyScheduleView.collectionView.delegate = self
        view.dailyScheduleView.collectionView.register(ScheduleCell.self, forCellWithReuseIdentifier: ScheduleCell.identifier)
        
        view.weeklyScheduleCollection.dataSource = self
        view.weeklyScheduleCollection.delegate = self
        view.weeklyScheduleCollection.register(DayColumnCell.self, forCellWithReuseIdentifier: DayColumnCell.identifier)
        
//        view.collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        
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
        
        self.setNavigationItems()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        self.scheduleView.overlayView.addGestureRecognizer(tapGesture)
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            self.loadSchedules()
        }
        
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            if(self.traitCollection.userInterfaceStyle == .light){
                self.scheduleView.viewModeSelector.segmentImage = UIImage(color: UIColor.systemBackground)
            } else {
                self.scheduleView.viewModeSelector.segmentImage = UIImage(color: UIColor.systemBackground)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.selectedWeekday = Calendar.current.component(.weekday, from: Date()) - 1
        
        self.loadSchedules()
        
        self.setDaysStack(self.scheduleView.dailyScheduleView.daysStack)
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
        
        self.navigationItem.rightBarButtonItems = [addItem]
        
        self.navigationItem.title = self.viewModel.getTitleString()
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font : UIFont(name: Fonts.coconRegular, size: Fonts.titleSize)!, .foregroundColor : UIColor(named: "system-text") as Any]
    }
    
    func reloadCollections() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.scheduleView.dailyScheduleView.collectionView.reloadData()
            self.scheduleView.weeklyScheduleCollection.reloadData()
        }
    }
    
    func unselectDays() {
        let dayViews = self.scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }
        
        dayViews.forEach { dayView in
            if let dayOfWeek = dayView.dayOfWeek {
                dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: false, isToday: dayOfWeek.isToday)
            }
        }
    }
    
    func selectToday() {
        let dayViews = self.scheduleView.dailyScheduleView.daysStack.arrangedSubviews.compactMap { $0 as? DayView }
        
        dayViews.forEach { dayView in
            if let dayOfWeek = dayView.dayOfWeek {
                if dayOfWeek.isToday {
                    dayView.dayOfWeek = DayOfWeek(day: dayOfWeek.day, date: dayOfWeek.date, isSelected: true, isToday: dayOfWeek.isToday)
                    self.viewModel.selectedDate = self.viewModel.daysOfWeek[dayView.tag]
                }
            }
        }
    }
    
    @objc private func addScheduleButtonTapped() {
        let newAlpha: CGFloat = self.scheduleView.overlayView.alpha == 0 ? 1 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.scheduleView.overlayView.alpha = newAlpha
            self.scheduleView.elipseView.alpha = newAlpha
            self.scheduleView.createAcitivityButton.alpha = newAlpha
            self.scheduleView.startActivityButton.alpha = newAlpha
        }
    }
    
    func loadSchedules() {
        self.viewModel.fetchSchedules()
        
        self.setContentView()
        
        self.reloadCollections()
    }
    
    @objc private func viewTapped(_ gesture: UITapGestureRecognizer) {
        self.dismissButtons()
    }
    
    func dismissButtons() {
        if self.scheduleView.overlayView.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.scheduleView.overlayView.alpha = 0
                self.scheduleView.elipseView.alpha = 0
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

// MARK: - Sheet Delegate
extension ScheduleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        self.loadSchedules()
        
        return nil
    }
}

// MARK: - UI Setup
extension ScheduleViewController {
    func setContentView() {
        self.scheduleView.dailyScheduleView.contentView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
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
            var childSubview = UIView()
            
            if let subjects = self.viewModel.subjectManager.fetchSubjects(),
               subjects.count > 0 {
                // Se fetchSubject() não for nulo
                self.scheduleView.changeEmptyView(isDaily: isDaily)
                
                self.handleTip()
                
                childSubview = self.scheduleView.emptyView
            } else {
                // Se fetchSubject() for nulo
                childSubview = self.scheduleView.noSubjectsView
            }
            
            if isDaily {
                self.addContentSubview(parentSubview: self.scheduleView.dailyScheduleView.contentView, childSubview: childSubview)
                self.addContentSubview(parentSubview: self.scheduleView.contentView, childSubview: self.scheduleView.dailyScheduleView)
            } else {
                self.addContentSubview(parentSubview: self.scheduleView.contentView, childSubview: childSubview)
            }
        } else {
            if isDaily {
                self.addContentSubview(parentSubview: self.scheduleView.dailyScheduleView.contentView, childSubview: self.scheduleView.dailyScheduleView.collectionView)
                self.addContentSubview(parentSubview: self.scheduleView.contentView, childSubview: self.scheduleView.dailyScheduleView)
            } else {
                self.addContentSubview(parentSubview: self.scheduleView.contentView, childSubview: self.scheduleView.weeklyScheduleCollection)
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
            childSubview.bottomAnchor.constraint(equalTo: parentSubview.bottomAnchor)
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
