//
//  Notifications.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/04/20.
//

import UIKit


struct NotificationManager {
    static func addNewNotification(_ item: DateCountModel) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "D-day"
        notificationContent.body = item.title
        
        var date = Calendar.current.dateComponents([.year, .month, .day], from: item.date)
        date.hour = 0
        print(date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "\(item.title) \(item.createDate)", content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func removeNotification(_ item: DateCountModel) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(item.title) \(item.createDate)"])
    }
}
