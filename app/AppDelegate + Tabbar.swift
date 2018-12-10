//
//  AppDelegate + Tabbar.swift
//  app
//
//  Created by Amir Hossein on 12/4/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate : UITabBarControllerDelegate{
    
    
    func initializeTabbar()  {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarRoot") as? UITabBarController
        //        self.tabBarController=self.window?.rootViewController as? UITabBarController
        
        self.tabBarController?.delegate=self
        
        window!.rootViewController = self.tabBarController
        
        initializeAllTabs()
        
        window!.makeKeyAndVisible()
    }
    
    
    func initializeAllTabs() {
        initializeTabsViewControllers()
    }
    
    func initializeTabsViewControllers()  {
        
        guard let tabs = self.tabBarController?.viewControllers as? [UINavigationController] else {
            print("There is something wrong with tabbar controller")
            return
        }
        
        let homeViewController=HomeViewController(
            nibName: HomeViewController.identifier,
            bundle: HomeViewController.bundle
        )
        tabs[TabIndex.HOME].pushViewController(homeViewController, animated: true)
        
        let myGiftsViewController=MyGiftsViewController(
            nibName: MyGiftsViewController.identifier,
            bundle: MyGiftsViewController.bundle
        )
        tabs[TabIndex.MyGifts].pushViewController(myGiftsViewController, animated: true)
        
        let registerGiftViewController=RegisterGiftViewController(
            nibName: RegisterGiftViewController.identifier,
            bundle: RegisterGiftViewController.bundle
        )
        tabs[TabIndex.RegisterGift].pushViewController(registerGiftViewController, animated: true)
        
        let requestsViewController=RequestsViewController(
            nibName: RequestsViewController.identifier,
            bundle: RequestsViewController.bundle
        )
        tabs[TabIndex.Requests].pushViewController(requestsViewController, animated: true)
        
        let myKindnessWallViewController=MyKindnessWallViewController(
            nibName: MyKindnessWallViewController.identifier,
            bundle: MyKindnessWallViewController.bundle
        )
        tabs[TabIndex.MyKindnessWall].pushViewController(myKindnessWallViewController, animated: true)
        
        
        self.tabBarController?.selectedIndex = TabIndex.HOME
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _=keychain.get(AppConstants.Authorization) {
            return true
        }
        
        if let _=(viewController as? UINavigationController)?.viewControllers.first as? RegisterGiftViewController {
            showLoginVC()
            return false
        }
        
        if let _=(viewController as? UINavigationController)?.viewControllers.first as? MyGiftsViewController {
            showLoginVC()
            return false
        }
        
        if let _=(viewController as? UINavigationController)?.viewControllers.first as? RequestsViewController {
            showLoginVC()
            return false
        }
        
        return true
        
    }
}
