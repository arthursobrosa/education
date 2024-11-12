//
//  AppDelegate.swift
//  Education
//
//  Created by Arthur Sobrosa on 13/06/24.
//

import CoreData
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
import TipKit
import UIKit
import UXCam

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        
        UXCam.optIntoSchematicRecordings()
        let configuration = UXCamConfiguration(appKey: "p40ljalqy03uxcg")
        configuration.enableAdvancedGestureRecognition = true
        UXCam.start(with: configuration)
        
        try? Tips.configure()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

