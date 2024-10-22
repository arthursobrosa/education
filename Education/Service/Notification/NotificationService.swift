//
//  NotificationService.swift
//  Education
//
//  Created by Leandro Silva on 30/07/24.
//

import UIKit
import UserNotifications

protocol NotificationProtocol {
    var notificationCenter: UNUserNotificationCenter { get set }
    
    func setDelegate(_ delegate: (any UNUserNotificationCenterDelegate)?)
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    func scheduleEndNotification(title: String, subjectName: String?, date: Date)
    func scheduleWeeklyNotification(title: String, body: String, date: Date)
    func scheduleWeeklyNotificationAtExactTime(title: String, body: String, date: Date, subjectName: String, startTime: Date, endTime: Date)
    func cancelAllNotifications()
    func cancelNotificationByName(name: String?)
    func cancelNotifications(forDate date: Date)
    func getActiveNotifications(completion: @escaping ([UNNotificationRequest]) -> Void)
    func getNotificationDate(for activityManager: ActivityManager?) -> Date?
}

class NotificationService: NotificationProtocol {
    var notificationCenter: UNUserNotificationCenter = .current()
    
    func setDelegate(_ delegate: (any UNUserNotificationCenterDelegate)?) {
        notificationCenter.delegate = delegate
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    func scheduleEndNotification(title: String, subjectName: String?, date: Date) {
        let body = subjectName ?? String(localized: "newActivity")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["subjectName": body]
        
        let triggerComponents = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let requestId = body
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWeeklyNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -5, to: date)!
        let triggerComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let dateString = dateFormatter.string(from: date)
        
        let requestId = "\(dateString)-5"
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWeeklyNotificationAtExactTime(title: String, body: String, date: Date, subjectName: String, startTime: Date, endTime: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["subjectName": subjectName, "startTime": startTime, "endTime": endTime]
        
        let triggerComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let dateString = dateFormatter.string(from: date)
        
        let requestId = "\(dateString)"
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func cancelNotificationByName(name: String?) {
        let id = name ?? String(localized: "newActivity")
        
        notificationCenter.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }
            
            let requestIds = requests.filter { $0.identifier.hasPrefix(id) }.map { $0.identifier }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: requestIds)
        }
    }
    
    func cancelNotifications(forDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let dateString = dateFormatter.string(from: date)
        
        notificationCenter.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }
            
            let requestIds = requests.filter { $0.identifier.hasPrefix(dateString) }.map { $0.identifier }
            notificationCenter.removePendingNotificationRequests(withIdentifiers: requestIds)
        }
    }
    
    func getActiveNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
    
    func getNotificationDate(for activityManager: ActivityManager?) -> Date? {
        guard let activityManager else { return nil }
        
        guard case .pomodoro(let workTime, let restTime, let numberOfLoops) = activityManager.timerCase else {
            return nil
        }
        
        let loopTime = workTime + restTime
        let totalTime = loopTime * numberOfLoops
        let timePassed = Double(activityManager.currentLoop * loopTime) + Date().timeIntervalSince(activityManager.startTime ?? Date())
        
        let timeLeft = Double(totalTime) - timePassed
        
        return  Date() + timeLeft
    }
}
