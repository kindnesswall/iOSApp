//
//  AppDelegate + Notification.swift
//  app
//
//  Created by Amir Hossein on 6/28/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let data = (userInfo["data"] as? String)?.data(using: .utf8),
            let message = ApiUtility.convert(data:data , to: TextMessage.self)
        else {
            completionHandler(.failed)
            return
        }
        
        self.appCoordinator.refreshChat(id: message.chatId)
    }
}
