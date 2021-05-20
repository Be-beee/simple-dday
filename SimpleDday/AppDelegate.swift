//
//  AppDelegate.swift
//  SimpleDday
//
//  Created by 서보경 on 2021/03/18.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DdayData.shared.loadListData()
        DdayData.shared.loadLabelsData()
        
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization()
        
        // resize Image in prev version
        if UserDefaults.shared?.value(forKey: "isResizedImage") == nil {
            if !DdayData.shared.ddayList.isEmpty {
                var newDdayList: [DateCountModel] = []
                for item in DdayData.shared.ddayList {
                    var newItem = item
                    let originalImage = item.dataToImage() ?? UIImage()
                    let resizedImage = ResizingManager.resizeImage(image: originalImage)
                    newItem.bgImage = resizedImage?.jpegData(compressionQuality: 0.9) ?? Data()
                    newDdayList.append(newItem)
                }
                DdayData.shared.ddayList = newDdayList
                DdayData.shared.saveData()
            }
            UserDefaults.shared?.set(true, forKey: "isResizedImage")
        }
        
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
}
