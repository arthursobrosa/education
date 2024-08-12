//
//  NotificationService.swift
//  Education
//
//  Created by Leandro Silva on 30/07/24.
//

import UIKit
import UserNotifications

class NotificationService {
    
    static let shared = NotificationService()
    
    private init() {
        // Private initializer to ensure singleton instance
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
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
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleWeeklyNotificationAtExactTime(title: String, body: String, date: Date, subjectName: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["subjectName": subjectName]
        
        let triggerComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let dateString = dateFormatter.string(from: date)
        
        let requestId = "\(dateString)"
        let request = UNNotificationRequest(identifier: requestId, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func cancelNotifications(forDate date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        let dateString = dateFormatter.string(from: date)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let requestIds = requests.filter { $0.identifier.hasPrefix(dateString) }.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestIds)
        }
    }
    
    func getActiveNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}

//// Uso do método para obter todas as notificações ativas
//NotificationService.shared.getActiveNotifications { requests in
//    for request in requests {
//        print("Title: \(request.content.title), Body: \(request.content.body), Identifier: \(request.identifier)")
//    }
//}
//
//// Exemplo de uso para agendar uma notificação
//let activityId = "atividade_123"
//NotificationService.shared.scheduleWeeklyNotification(activityId: activityId, title: "Estudo", body: "Hora de estudar!", date: Date())
//NotificationService.shared.scheduleWeeklyNotificationAtExactTime(activityId: activityId, title: "Revisão", body: "Hora de revisar!", date: Date())
//
//// Exemplo de uso para cancelar notificações de uma atividade
//NotificationService.shared.cancelNotifications(forActivityId: activityId)
