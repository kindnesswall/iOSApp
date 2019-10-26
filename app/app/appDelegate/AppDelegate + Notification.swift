//
//  AppDelegate + Notification.swift
//  app
//
//  Created by Amir Hossein on 6/28/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate {
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }        
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        saveDeviceIdentifierAndPushToken(pushToken: token)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        saveDeviceIdentifierAndPushToken(pushToken: nil)
    }
    
    private func saveDeviceIdentifierAndPushToken(pushToken:String?){
        
        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
        saveOrDelete(value: deviceIdentifier, key: AppConst.KeyChain.DeviceIdentifier)
        saveOrDelete(value: pushToken, key: AppConst.KeyChain.PushToken)
        
        print("Device Identifier: \(deviceIdentifier ?? "")")
        print("Push Token: \(pushToken ?? "")")
        
        registerPush(deviceIdentifier: deviceIdentifier, pushToken: pushToken)
    }
    
    private func saveOrDelete(value:String?,key:String) {
        if let value = value {
            keychain.set(value, forKey: key)
        } else {
            keychain.delete(key)
        }
    }
    
    func registerPush(){
        registerPush(deviceIdentifier: keychain.get(AppConst.KeyChain.DeviceIdentifier),pushToken: keychain.get(AppConst.KeyChain.PushToken))
    }

    func registerPush(deviceIdentifier:String?,pushToken:String?){
        guard AppDelegate.me().appViewModel.isUserLogedIn(),
            let deviceIdentifier = deviceIdentifier,
            let pushToken = pushToken
        else { return }

        let input = PushNotificationRegister(deviceIdentifier: deviceIdentifier, devicePushToken: pushToken)

        self.apiService.registerPush(input: input) { _ in }
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        guard let data = (userInfo["data"] as? String)?.data(using: .utf8),
            let message = ApiUtility.convert(data:data , to: TextMessage.self)
        else {
            completionHandler(.failed)
            return
        }
        
        self.appCoordinator.tabBarController.refreshChatProtocol?.fetchChat(chatId: message.chatId)
    }
}
