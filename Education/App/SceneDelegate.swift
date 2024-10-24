//
//  SceneDelegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?
    
    private var currentDate = Date()
    private var timerSeconds = Int()
    
    var activityManager: ActivityManager?
    var notificationService: NotificationServiceProtocol?
    var blockingManager: BlockingManager?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        blockingManager = BlockAppsMonitor()
        notificationService = NotificationService()
        notificationService?.setDelegate(self)
        activityManager = ActivityManager(notificationService: notificationService)
        
        window = UIWindow(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        
        coordinator = SplashCoordinator(navigationController: UINavigationController(), activityManager: activityManager, blockingManager: blockingManager, notificationService: notificationService)
        coordinator?.start()
        
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        CoreDataStack.shared.saveMainContext()
        blockingManager?.removeShields()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        let timeInBackground = Date().timeIntervalSince(currentDate)
        
        activityManager?.updateAfterBackground(timeInBackground: timeInBackground, lastTimerSeconds: timerSeconds)
        
        guard let coordinator else { return }
        
        if let tabBar = coordinator.navigationController.viewControllers.last as? TabBarController {
            guard tabBar.selectedIndex == 3,
                  let settingsVC = tabBar.settings.navigationController.viewControllers.first as? SettingsViewController else { return }
            
            settingsVC.viewModel.requestNoficationsAuthorization()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        guard let activityManager,
              !activityManager.isPaused else { return }
        
        currentDate = Date()
        timerSeconds = activityManager.timerSeconds
        
        switch activityManager.timerCase {
            case .pomodoro:
                activityManager.stopTimer()
            default:
                break
        }
        
        var date = Date()
        
        switch activityManager.timerCase {
            case .timer:
                date = Calendar.current.date(byAdding: .second, value: activityManager.timerSeconds, to: Date.now)!
            case .pomodoro:
                guard let notificationDate = notificationService?.getNotificationDate(for: activityManager) else { return }
                
                date = notificationDate
            default:
                break
        }
        
        notificationService?.scheduleEndNotification(
            title: String(localized: "timerAlertMessage"),
            subjectName: activityManager.subject?.unwrappedName,
            date: date)
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        guard let subjectName = userInfo["subjectName"] as? String,
              let startTime = userInfo["startTime"] as? Date,
              let endTime = userInfo["endTime"] as? Date else {
            completionHandler()
            return
        }
        
        showScheduleNotification(subjectName: subjectName, startTime: startTime, endTime: endTime)

        completionHandler()
    }
    
    private func showScheduleNotification(subjectName: String, startTime: Date, endTime: Date) {
        guard let coordinator else { return }
        
        if let splashCoordinator = coordinator as? SplashCoordinator {
            splashCoordinator.scheduleNotification = SplashCoordinator.ScheduleNotification(subjectName: subjectName, startTime: startTime, endTime: endTime)
        }
        
        if let tabBar = coordinator.navigationController.viewControllers.last as? TabBarController {
            tabBar.selectedIndex = 0
            tabBar.schedule.showScheduleNotification(subjectName: subjectName, startTime: startTime, endTime: endTime)
        }
    }
}
