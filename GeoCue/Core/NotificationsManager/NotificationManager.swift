//
//  NotificationManager.swift
//  GeoCue
//
//  Created by Haris  on 16/02/2025.
//

import Foundation
import UserNotifications

//final class NotificationManager {
//    static let shared = NotificationManager()
//    private init() {}
//    
//    func requestAuthorization() {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
//            if let error = error {
//                print("Notification authorization error: \(error.localizedDescription)")
//            } else {
//                print("Notification authorization granted: \(granted)")
//            }
//        }
//    }
//    
//    func sendNotification(title: String, body: String) {
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body  = body
//        content.sound = .default
//        
//        let request = UNNotificationRequest(identifier: UUID().uuidString,
//                                            content: content,
//                                            trigger: nil)  // Fire immediately
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            }
//        }
//    }
//}


import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    public override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else {
                print("Notification authorization granted: \(granted)")
            }
        }
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: nil)  // Fire immediately
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - UNUserNotificationCenterDelegate

    // This method will be called when the app is in the foreground.
    // You can choose to show an alert, banner, sound, or none.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
}
