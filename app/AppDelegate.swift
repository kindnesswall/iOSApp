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
    public var tabBarController:UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.tabBarController=self.window?.rootViewController as? UITabBarController
        self.tabBarController?.selectedIndex = 1
        
        let tab0=self.tabBarController!.viewControllers![0] as! UINavigationController
        let controller0=MyWallViewController(nibName: "MyWallViewController", bundle: Bundle(for: MyWallViewController.self))
        tab0.pushViewController(controller0, animated: true)
        
        let tab1=self.tabBarController!.viewControllers![1] as! UINavigationController
        let controller1=HomeViewController(nibName: "HomeViewController", bundle: Bundle(for: HomeViewController.self))
        tab1.pushViewController(controller1, animated: true)
        
        return true
    }


}

