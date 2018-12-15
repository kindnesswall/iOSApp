//
//  AppDelegate.swift
//  app
//
//  Created by Hamed.Gh on 10/10/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let uDStandard = UserDefaults.standard
    let uDStandard = UserDefaults.standard
    let keychain = KeychainSwift()

    var current_time:Time?

    public var tabBarController:UITabBarController?

    static let screenWidth = UIScreen.main.bounds.width
    var launchedShortcutItem: UIApplicationShortcutItem?

    static func clearUserDefaultAuthValues() {
        
        let watched_select_language = uDStandard.bool(forKey: AppConstants.WATCHED_SELECT_LANGUAGE)
        let watched_intro = uDStandard.bool(forKey: AppConstants.WATCHED_INTRO)
        
        clearAllUserDefaultValues()
        
        uDStandard.set(watched_select_language, forKey: AppConstants.WATCHED_SELECT_LANGUAGE)
        uDStandard.set(watched_intro, forKey: AppConstants.WATCHED_INTRO)
        
        uDStandard.synchronize()
    }
    
    
    static func clearAllUserDefaultValues(){
        let domain = Bundle.main.bundleIdentifier!
        uDStandard.removePersistentDomain(forName: domain)
        uDStandard.synchronize()
        
        print("clearUserDefault : ")
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("\n\ndidFinishLaunchingWithOptions\n\n")

        UIView.appearance().semanticContentAttribute = .forceLeftToRight

        if uDStandard.bool(forKey: AppConstants.WATCHED_SELECT_LANGUAGE) {
            showTabbarIntro()
        }else{
            showSelectLanguageVC()
        }
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            _ = handleShortCut(shortcutItem)
            
        }
        
        return true
    }
    
    func handleShortCut(_ item: UIApplicationShortcutItem) -> Bool {
        if item.type == "ir.kindnesswall.publicusers.DonateGift" {
            // shortcut was triggered!
            //                showTabbarIntro()
            self.tabBarController?.selectedIndex = TabIndex.RegisterGift
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
        
        if !uDStandard.bool(forKey: AppConstants.WATCHED_INTRO) {
            showIntro()
            uDStandard.set(true, forKey: AppConstants.WATCHED_INTRO)
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
    
    
    func showIntro() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        self.tabBarController?.present(viewController, animated: true, completion: nil)

    }
    func showLoginVC(){
        let controller=ActivationEnterPhoneViewController(
            nibName: ActivationEnterPhoneViewController.identifier,
            bundle: ActivationEnterPhoneViewController.bundle
        )
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
    }
    
    func checkForLogin()->Bool{
        if let _=keychain.get(AppConstants.Authorization) {
            return true
        }
        showLoginVC()
        return false
    }
    
    
}

