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
        
        initiateTab(tabIndex: TabIndex.HOME,tabs:tabs)
        initiateTab(tabIndex: TabIndex.MyGifts,tabs:tabs)
        initiateTab(tabIndex: TabIndex.RegisterGift,tabs:tabs)
        initiateTab(tabIndex: TabIndex.Requests,tabs:tabs)
        initiateTab(tabIndex: TabIndex.MyKindnessWall,tabs:tabs)
        
        self.tabBarController?.selectedIndex = TabIndex.HOME
        
    }
    
    func getTabViewController(tabIndex:Int)->UIViewController{
        var controller:UIViewController
        switch tabIndex {
        case TabIndex.HOME:
            controller=HomeViewController(
                nibName: HomeViewController.identifier,
                bundle: HomeViewController.bundle
            )
            
        case TabIndex.MyGifts:
            controller=MyGiftsViewController(
                nibName: MyGiftsViewController.identifier,
                bundle: MyGiftsViewController.bundle
            )
            
        case TabIndex.RegisterGift:
            controller=RegisterGiftViewController(
                nibName: RegisterGiftViewController.identifier,
                bundle: RegisterGiftViewController.bundle
            )
            
        case TabIndex.Requests:
            controller=RequestsViewController(
                nibName: RequestsViewController.identifier,
                bundle: RequestsViewController.bundle
            )
        case TabIndex.MyKindnessWall:
            controller=MyKindnessWallViewController(
                nibName: MyKindnessWallViewController.identifier,
                bundle: MyKindnessWallViewController.bundle
            )
        default:
            fatalError()
        }
        
        return controller
    }
    
    func initiateTab(tabIndex:Int,tabs:[UINavigationController]) {
        tabs[tabIndex].setViewControllers([getTabViewController(tabIndex:tabIndex)], animated: false)
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let auth=keychain.get(AppConst.KeyChain.Authorization)
        
        if auth==nil,
            authIsMandatory(for: viewController)
            {
            showLoginVC()
            return false
        }
        
        if (viewController as? UINavigationController)?.viewControllers.first as? RequestsViewController != nil {
            if let tabs = self.tabBarController?.viewControllers as? [UINavigationController] {
                initiateTab(tabIndex: TabIndex.Requests, tabs: tabs)
            }
        }
        
        return true
        
    }
    
    private func authIsMandatory(for viewController:UIViewController)->Bool {
        if
            (viewController as? UINavigationController)?.viewControllers.first as? RegisterGiftViewController != nil
            ||
            (viewController as? UINavigationController)?.viewControllers.first as? MyGiftsViewController != nil
            ||
            (viewController as? UINavigationController)?.viewControllers.first as? RequestsViewController != nil  {
            return true
        }
        
        return false
    }
}
