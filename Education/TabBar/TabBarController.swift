//
//  TabBarController.swift
//  Education
//
//  Created by Leandro Silva on 03/07/24.
//

import UIKit

class TabBarController: UITabBarController {
    let themeListViewModel: ThemeListViewModel
    let schedule = ScheduleCoordinator(navigationController: UINavigationController())
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
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTab"), image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: String(localized: "subjectTab"), image: UIImage(systemName: "books.vertical"), tag: 1)
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: String(localized: "themeTab"), image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
        
        profile.start()
        profile.navigationController.tabBarItem = UITabBarItem(title: String(localized: "profileTab"), image: UIImage(systemName: "person"), tag: 3)
        
        self.viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, profile.navigationController]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.view.bounds.width
        let height = width * (72/390)
        
        self.activityView.frame = CGRect(x: 0, y: self.view.bounds.height - self.tabBar.frame.height - (height + 20), width: width, height: height)
    }
    
    @objc private func activityButtonTapped() {
        guard self.activityView.timerSeconds > 0 else { return }
        
        self.activityView.isPaused.toggle()
        
        if self.activityView.isPaused {
            ActivityManager.shared.timer.invalidate()
        } else {
            ActivityManager.shared.startTimer()
        }
    }
    
    @objc private func activityViewTapped() {
        guard let focusSessionModel = ActivityManager.shared.focusSessionModel else { return }
        
        focusSessionModel.timerState = self.activityView.isPaused ? .reseting : .starting
        
        self.selectedIndex = self.schedule.navigationController.tabBarItem.tag
        
        self.schedule.showTimer(focusSessionModel: focusSessionModel)
        
        ActivityManager.shared.isShowingActivity = false
    }
}
