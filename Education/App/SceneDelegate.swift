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
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UNUserNotificationCenter.current().delegate = self
        
        window = UIWindow(windowScene: windowScene)
        window?.frame = windowScene.coordinateSpace.bounds
        
        let themeListViewModel = ThemeListViewModel()
        coordinator = SplashCoordinator(navigationController: UINavigationController(), themeListViewModel: themeListViewModel)
        coordinator?.start()
        
        window?.rootViewController = coordinator?.navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        BlockAppsMonitor.shared.removeShields()
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
        let timeInBackground = Date().timeIntervalSince(self.currentDate)
        
        ActivityManager.shared.updateAfterBackground(timeInBackground: timeInBackground, lastTimerSeconds: self.timerSeconds)
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        self.currentDate = Date()
        self.timerSeconds = ActivityManager.shared.timerSeconds
        
        switch ActivityManager.shared.timerCase {
        case .pomodoro:
            ActivityManager.shared.stopTimer()
        default:
            break
        }
        
        guard !ActivityManager.shared.isPaused else { return }
        
        switch ActivityManager.shared.timerCase {
        case .timer:
            NotificationService.shared.scheduleEndNotification(
                title: String(localized: "timerAlertMessage"),
                body: ActivityManager.shared.subject!.unwrappedName,
                date: Calendar.current.date(byAdding: .second, value: ActivityManager.shared.timerSeconds, to: Date.now)!,
                subjectName: ActivityManager.shared.subject!.unwrappedName)
            
        case .pomodoro(_, _, _):
            NotificationService.shared.scheduleEndNotification(
                title: String(localized: "timerAlertMessage"),
                body: ActivityManager.shared.subject!.unwrappedName,
                date: notificationDate(),
                subjectName: ActivityManager.shared.subject!.unwrappedName)
        default:
            break
        }
        
        CoreDataStack.shared.saveMainContext()
    }
    
    func notificationDate() -> Date{
        let pomodoro = ActivityManager.shared
        
        let loopTime = pomodoro.workTime + pomodoro.restTime
        let totalTime = loopTime * pomodoro.numberOfLoops
        let timePassed = Double(pomodoro.currentLoop * loopTime) + Date().timeIntervalSince(pomodoro.startTime ?? Date())
        
        let timeLeft = Double(totalTime) - timePassed
        
        return  Date() + timeLeft
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let name = userInfo["subjectName"] as? String {
            let subjectManager = SubjectManager()
            let subject = subjectManager.fetchSubject(withName: name)
            
            self.showFocusSelection(color: .systemBlue, subject: subject)
        }
        
        completionHandler()
    }
    
    private func showFocusSelection(color: UIColor?, subject: Subject?) {
        guard let coordinator else { return }
        
        if let tabBar = coordinator.navigationController.viewControllers.last as? TabBarController {
            let newFocusSessionModel = FocusSessionModel(subject: subject, color: color)
            
            tabBar.selectedIndex = 0
            tabBar.schedule.showFocusSelection(focusSessionModel: newFocusSessionModel)
        }
    }
}
