//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    let themeListViewModel: ThemeListViewModel
    private let schedule = ScheduleCoordinator(navigationController: UINavigationController())
    private let studytime = StudyTimeCoordinator(navigationController: UINavigationController())
    private lazy var themeList = ThemeListCoordinator(navigationController: UINavigationController(), themeListViewModel: self.themeListViewModel)
    private let profile = ProfileCoordinator(navigationController: UINavigationController())
    
    lazy var activityView: ActivityView = {
        let view = ActivityView()
        view.activityButton.addTarget(self, action: #selector(activityButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(activityViewTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    init(themeListViewModel: ThemeListViewModel) {
        self.themeListViewModel = themeListViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundColor = .systemBackground
        
        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTabTitle"), image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: "Subjects", image: UIImage(systemName: "books.vertical"), tag: 1)
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: "Exams", image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
        
        profile.start()
        profile.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        self.viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, profile.navigationController]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.view.bounds.width
        let height = width * (72/390)
        
        self.activityView.frame = CGRect(x: 0, y: self.view.bounds.height - self.tabBar.frame.height - (height + 20), width: width, height: height)
    }
    
    @objc private func activityButtonTapped() {
        self.activityView.isPaused.toggle()
        ActivityManager.shared.isPaused.toggle()
        
        if self.activityView.isPaused {
            ActivityManager.shared.timer.invalidate()
        } else {
            ActivityManager.shared.startTimer()
        }
        
    }
    
    @objc private func activityViewTapped() {
        self.selectedIndex = schedule.navigationController.tabBarItem.tag
        schedule.color = self.activityView.color
        
        let timerState: FocusSessionViewModel.TimerState? = self.activityView.isPaused ? .reseting : nil
        
        schedule.showTimer(transitioningDelegate: self, timerState: timerState, totalSeconds: self.activityView.totalSeconds, timerSeconds: self.activityView.timerSeconds, subject: self.activityView.subject, timerCase: self.activityView.timerCase ?? .timer)
        
        ActivityManager.shared.isShowingActivity = false
    }
}
