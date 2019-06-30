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

    public var tabBarController:UITabBarController?
    weak var startNewChatProtocol:StartNewChatProtocol?
    
    var tabBarPagesRelaodDelegates = [ReloadablePage]()

    static let screenWidth = UIScreen.main.bounds.width
    var launchedShortcutItem: UIApplicationShortcutItem?

    
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
    
    func shareApp() {
        let text = "دیوار مهربانی، نیاز نداری بزار، نیاز داری بردار\n\n دانلود از سیب اپ:\nhttps://new.sibapp.com/applications/app-12\n\nدانلود از گوگل پلی:\nhttps://play.google.com/store/apps/details?id=ir.kindnesswall"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.window // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.tabBarController?.present(activityViewController, animated: true, completion: nil)
    }
    
    func showLockVC() {
        let controller = LockViewController()
        controller.mode = .CheckPassCode
        controller.isCancelable = false
        self.tabBarController?.present(controller, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("\n\ndidFinishLaunchingWithOptions\n\n")
        
        if uDStandard.object(forKey: AppConst.UserDefaults.FirstInstall) == nil {
            uDStandard.set(false, forKey: AppConst.UserDefaults.FirstInstall)
            uDStandard.synchronize()
            keychain.clear()
        }
        
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
            self.tabBarController?.selectedIndex = AppConst.TabIndex.RegisterGift
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
    
    func showTabbarIntro() {
        
        initializeTabbar()
        
        if !uDStandard.bool(forKey: AppConst.UserDefaults.WATCHED_INTRO) {
            showIntro()
            uDStandard.set(true, forKey: AppConst.UserDefaults.WATCHED_INTRO)
            uDStandard.synchronize()
        }
    }
    
    func showSelectLanguageVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LanguageViewController()
        viewController.languageViewModel.tabBarIsInitialized = false
        //        let nc = UINavigationController.init(rootViewController: viewController)
        window!.rootViewController = viewController
        window!.makeKeyAndVisible()
    }
    
    func showSelectCountryVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = SelectCountryVC()
        vc.vm.tabBarIsInitialized = false
        //        let nc = UINavigationController.init(rootViewController: viewController)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
    }
    
    
    func showIntro() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: IntroViewController.identifier) as! IntroViewController
        self.tabBarController?.present(viewController, animated: true, completion: nil)
        
    }
    
    func isIranSelected() -> Bool {
        let selectedCountry = uDStandard.string(forKey: AppConst.UserDefaults.SELECTED_COUNTRY)
        return selectedCountry == AppConst.Country.IRAN
    }
    
}

