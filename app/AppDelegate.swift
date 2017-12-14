//
//  AppDelegate.swift
//  app
//
//  Created by Hamed.Gh on 10/10/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let uDStandard = UserDefaults.standard
    let uDStandard = UserDefaults.standard
    
    public var tabBarController:UITabBarController?

    static func clearUserDefault() {
        let domain = Bundle.main.bundleIdentifier!
        uDStandard.removePersistentDomain(forName: domain)
        uDStandard.synchronize()
        
        print("clearUserDefault : ")
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }
    
    func pushViewControllersIntoTabs()  {
        if var tabs = self.tabBarController?.viewControllers as? [UINavigationController] {
            
            // Tab0
            let controller0=RegisterGiftViewController(nibName: "RegisterGiftViewController", bundle: Bundle(for: RegisterGiftViewController.self))
            tabs[TabIndex.RegisterGift].pushViewController(controller0, animated: true)
            
            let controller1=RequestsViewController(nibName: "RequestsViewController", bundle: Bundle(for: RequestsViewController.self))
            tabs[TabIndex.Requests].pushViewController(controller1, animated: true)
            
            let controller2=HomeViewController(nibName: "HomeViewController", bundle: Bundle(for: HomeViewController.self))
            tabs[TabIndex.HOME].pushViewController(controller2, animated: true)
            
            let controller3=MyKindnessWallViewController(nibName: "MyKindnessWallViewController", bundle: Bundle(for: MyKindnessWallViewController.self))
            tabs[TabIndex.MyKindnessWall].pushViewController(controller3, animated: true)
            
            self.tabBarController?.viewControllers = tabs
            self.tabBarController?.selectedIndex = 0
        } else {
            print("There is something wrong with tabbar controller")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        showTabbar()
        
        if uDStandard.bool(forKey: AppConstants.WATCHED_INTRO) {
            showIntro()
            uDStandard.set(true, forKey: AppConstants.WATCHED_INTRO)
        }
        
        return true
    }
    
    func showTabbar()  {
        
        self.tabBarController=self.window?.rootViewController as? UITabBarController
        
        pushViewControllersIntoTabs()
    }
    
    func showIntro() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        self.tabBarController?.present(viewController, animated: true, completion: nil)

    }
}

