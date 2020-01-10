//
//  AppViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class AppViewModel {
    let apiService = ApiService(HTTPLayer())
    let keychainService = KeychainService()
    let userDefaultService = UserDefaultService()
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in

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

    func registerPush() {
        registerPush(deviceIdentifier: keychainService.getString(.deviceIdentifier), pushToken: keychainService.getString(.pushToken))
    }

    func registerPush(deviceIdentifier: String?, pushToken: String?) {
        guard keychainService.isUserLogedIn(),
            let deviceIdentifier = deviceIdentifier,
            let pushToken = pushToken
        else { return }

        let input = PushNotificationRegister(deviceIdentifier: deviceIdentifier, devicePushToken: pushToken)

        self.apiService.registerPush(input: input) { _ in }
    }
    
    func saveDeviceIdentifierAndPushToken(pushToken: String?) {

        guard let pushToken = pushToken, let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        keychainService.set(.deviceIdentifier, value: deviceIdentifier)
        keychainService.set(.pushToken, value: pushToken)

        print("Device Identifier: \(deviceIdentifier)")
        print("Push Token: \(pushToken)")

        registerPush(deviceIdentifier: deviceIdentifier, pushToken: pushToken)
    }

    func appOpenForTheFirstTime() {
        userDefaultService.appOpenForTheFirstTime()
        keychainService.clear()
    }
}
