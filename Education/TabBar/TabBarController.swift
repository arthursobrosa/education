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
    private let settings = SettingsCoordinator(navigationController: UINavigationController())
    
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
        
        ActivityManager.shared.delegate = self
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.darkModeOnMedium, size: 10)!
        ]
        self.tabBar.backgroundColor = .systemBackground
        
        schedule.start()
        schedule.navigationController.tabBarItem = UITabBarItem(title: String(localized: "scheduleTab"), image: UIImage(systemName: "calendar.badge.clock"), tag: 0)
        schedule.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        schedule.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        studytime.start()
        studytime.navigationController.tabBarItem = UITabBarItem(title: String(localized: "subjectTab"), image: UIImage(systemName: "books.vertical"), tag: 1)
        studytime.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        studytime.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        themeList.start()
        themeList.navigationController.tabBarItem = UITabBarItem(title: String(localized: "themeTab"), image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
        themeList.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        themeList.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        settings.start()
        settings.navigationController.tabBarItem = UITabBarItem(title: String(localized: "settingsTab"), image: UIImage(systemName: "gearshape"), tag: 3)
        settings.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .normal)
        settings.navigationController.tabBarItem.setTitleTextAttributes(titleAttributes, for: .selected)
        
        self.viewControllers = [schedule.navigationController, studytime.navigationController, themeList.navigationController, settings.navigationController]
        
        customizeTabBar()
        
                
    }
    
    func customizeTabBar(){
        self.tabBar.barTintColor = .white
        self.tabBar.backgroundColor = .clear
        self.tabBar.isTranslucent = true
        self.tabBar.tintColor = .label
        self.tabBar.frame = CGRect(x: 0, y: self.view.bounds.height - self.tabBar.frame.height, width: self.view.bounds.width, height: 80)
        
        // Criando a sublayer da tabbar
        let padding: CGFloat = 15.0
        let roundLayer = CAShapeLayer()
        let adjustedRect = CGRect(
            x: padding,
            y: self.tabBar.bounds.origin.y - 8,
            width: self.tabBar.bounds.width - padding * 2,
            height: self.tabBar.bounds.height - 10
        )
        roundLayer.path = UIBezierPath(roundedRect: adjustedRect, cornerRadius: 30).cgPath
        roundLayer.fillColor = UIColor.label.withAlphaComponent(0.1).cgColor
        
        // Adicionando sublayer na tab bar
        self.tabBar.layer.insertSublayer(roundLayer, at: 0)
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 5
        self.tabBar.layer.masksToBounds = false

        // Reagindo ao dark e light mode
        self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) {
            (self: Self, previousTraitCollection: UITraitCollection) in
            
            if let roundLayer = self.tabBar.layer.sublayers?.first(where: { $0 is CAShapeLayer }) as? CAShapeLayer {
                        roundLayer.fillColor = UIColor.label.withAlphaComponent(0.15).cgColor
                    }
            self.tabBar.tintColor = .label

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width = self.view.bounds.width
        let height = width * (72/390)
        
        self.activityView.frame = CGRect(x: 0, y: self.view.bounds.height - self.tabBar.frame.height - (height + 20), width: width, height: height)
    }
    
    @objc private func activityButtonTapped() {
        ActivityManager.shared.isPaused.toggle()
        self.activityView.isPaused.toggle()
    }
    
    @objc private func activityViewTapped() {
        self.selectedIndex = self.schedule.navigationController.tabBarItem.tag
        
        self.schedule.showTimer(focusSessionModel: nil)
    }
}
