//
//  AppDelegate.swift
//  app
//
//  Created by Hamed.Gh on 10/10/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static let uDStandard = UserDefaults.standard
    let uDStandard = UserDefaults.standard
    let keychain = KeychainSwift()
    var isActiveAfterBioAuth:Bool = false
    var current_time:Time?
    var apiRequest = ApiRequest(HTTPLayer())

    public var tabBarController = MainTabBarController()
    
    static let screenWidth = UIScreen.main.bounds.width
    var launchedShortcutItem: UIApplicationShortcutItem?

    func initializeTabbar()  {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = self.tabBarController.tabBarController
            
        self.tabBarController.initializeAllTabs()
        
        window!.makeKeyAndVisible()
    }
    
    public func isPasscodeSaved() -> Bool {
        if let _ = keychain.get(AppConst.KeyChain.PassCode) {
            return true
        }
        return false
    }
    
    private func clearAllUserDefaultValues(){
        let domain = Bundle.main.bundleIdentifier!
        uDStandard.removePersistentDomain(forName: domain)
        uDStandard.synchronize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("\n\ndidFinishLaunchingWithOptions\n\n")
        
        if uDStandard.object(forKey: AppConst.UserDefaults.FirstInstall) == nil {
            uDStandard.set(false, forKey: AppConst.UserDefaults.FirstInstall)
            uDStandard.synchronize()
            keychain.clear()
        }
        
        let token = "5sybCu3/uSGG6FFhfFqMJw=="
        keychain.set(AppConst.KeyChain.BEARER + " " + token, forKey: AppConst.KeyChain.Authorization)
        
        keychain.set(true, forKey: AppConst.KeyChain.IsAdmin)
        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        if uDStandard.string(forKey: AppConst.UserDefaults.SELECTED_COUNTRY) == nil {
            showSelectCountryVC()
        }else{
            checkLanguageSelectedOrNot()
        }
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            _ = handleShortCut(shortcutItem)
        }
        
        registerForPushNotifications()
        
        return true
    }
    
    func checkLanguageSelectedOrNot() {
        if uDStandard.bool(forKey: AppConst.UserDefaults.WATCHED_SELECT_LANGUAGE) {
            showTabbarIntro()
        }else{
            showSelectLanguageVC()
        }
    }
    
    func handleShortCut(_ item: UIApplicationShortcutItem) -> Bool {
        if item.type == "ir.kindnesswall.publicusers.DonateGift" {
            // shortcut was triggered!
            //                showTabbarIntro()
            self.tabBarController.tabBarController?.selectedIndex = AppConst.TabIndex.RegisterGift
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
        
        if isPasscodeSaved(), !isActiveAfterBioAuth {
            showLockVC()
        }
        isActiveAfterBioAuth = false
        
        guard let item = launchedShortcutItem else { return }
        print("there is one item")
        _ = handleShortCut(item)
        
        launchedShortcutItem = nil
        
        if (application.applicationIconBadgeNumber != 0) {
            application.applicationIconBadgeNumber = 0
        }
    }
    
    func isIranSelected() -> Bool {
        let selectedCountry = uDStandard.string(forKey: AppConst.UserDefaults.SELECTED_COUNTRY)
        return selectedCountry == AppConst.Country.IRAN
    }
    
}

