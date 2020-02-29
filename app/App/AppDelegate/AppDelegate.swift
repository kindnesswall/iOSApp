//
//  AppDelegate.swift
//  app
//
//  Created by Hamed.Gh on 10/10/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let keychainService = KeychainService()
    let userDefaultService = UserDefaultService()
    
    var isActiveAfterBioAuth: Bool = false
    var currentTime: Time?

    let appViewModel = AppViewModel()

    lazy var appCoordinator = AppCoordinator()
    static let screenWidth = UIScreen.main.bounds.width
    var launchedShortcutItem: UIApplicationShortcutItem?

    func showTabbarIntro() {

        appCoordinator.showTabBar()

        if !userDefaultService.isUserWatchedIntro() {
            appCoordinator.showIntro()
            userDefaultService.userWatchedIntro()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("\n\ndidFinishLaunchingWithOptions\n\n")

//        FirebaseApp.configure()

        if userDefaultService.isItFirstTimeAppOpen() {
            appViewModel.appOpenForTheFirstTime()
        }

        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        if AppCountry.isNotSelectedAnyCountry {
            appCoordinator.showSelectCountryVC()
        } else {
            checkLanguageSelectedOrNot()
        }

        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            _ = handleShortCut(shortcutItem)
        }

        appViewModel.registerForPushNotifications()

        return true
    }

    func checkLanguageSelectedOrNot() {
        if userDefaultService.isLanguageSelected() {
            showTabbarIntro()
        } else {
            appCoordinator.showSelectLanguageVC()
        }
    }

    func handleShortCut(_ item: UIApplicationShortcutItem) -> Bool {
        if item.type == "ir.kindnesswall.publicusers.DonateGift" {
            appCoordinator.showRegisterGiftTab()
            return true
        }
        return false
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Alternatively, a shortcut item may be passed in through this delegate method if the app was
        // still in memory when the Home screen quick action was used. Again, store it for processing.
        launchedShortcutItem = shortcutItem
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("\n\napplicationDidBecomeActive\n\n")

        if keychainService.isPasscodeSaved(), !isActiveAfterBioAuth {
            appCoordinator.showLockVC()
        }
        isActiveAfterBioAuth = false

        guard let item = launchedShortcutItem else { return }
        print("there is one item")
        _ = handleShortCut(item)

        launchedShortcutItem = nil

        if application.applicationIconBadgeNumber != 0 {
            application.applicationIconBadgeNumber = 0
        }
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        appViewModel.saveDeviceIdentifierAndPushToken(pushToken: token)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
        appViewModel.saveDeviceIdentifierAndPushToken(pushToken: nil)
    }

}
