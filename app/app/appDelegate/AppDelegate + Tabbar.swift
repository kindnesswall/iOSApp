//
//  AppDelegate + Tabbar.swift
//  app
//
//  Created by Amir Hossein on 12/4/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

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
        
        initiateTab(tabIndex: AppConst.TabIndex.HOME,tabs:tabs)
        initiateTab(tabIndex: AppConst.TabIndex.Charities,tabs:tabs)
        initiateTab(tabIndex: AppConst.TabIndex.RegisterGift,tabs:tabs)
        initiateTab(tabIndex: AppConst.TabIndex.Chat,tabs:tabs)
        initiateTab(tabIndex: AppConst.TabIndex.More,tabs:tabs)
        
        setTabsDelegates(tabs:tabs)
        
        self.tabBarController?.selectedIndex = AppConst.TabIndex.HOME
        
    }
    
    func resetAppAfterSwitchUser(){
        guard let tabs = self.tabBarController?.viewControllers as? [UINavigationController] else { return }
        
        initiateTab(tabIndex: AppConst.TabIndex.MyWall,tabs:tabs)
        initiateTab(tabIndex: AppConst.TabIndex.Chat,tabs:tabs)
    }
    
    func initiateTab(tabIndex:Int,tabs:[UINavigationController]) {
        tabs[tabIndex].setViewControllers([getTabViewController(tabIndex:tabIndex)], animated: false)
    }
    
    func getTabViewController(tabIndex:Int)->UIViewController{
        var controller:UIViewController
        switch tabIndex {
        case AppConst.TabIndex.HOME:
            controller=HomeViewController(vm: HomeVM())
        
        case AppConst.TabIndex.Charities:
            let charitiesViewController = CharityListViewController()
            controller = charitiesViewController
            
        case AppConst.TabIndex.MyWall:
            let myWallViewController = MyWallViewController()
            myWallViewController.userId = Int(KeychainSwift().get(AppConst.KeyChain.USER_ID) ?? "")
            controller = myWallViewController
            
        case AppConst.TabIndex.RegisterGift:
            controller=RegisterGiftViewController()
            
        case AppConst.TabIndex.Chat:
            let contactsViewController = ContactsViewController()
            self.startNewChatProtocol = contactsViewController.viewModel
            self.refreshChatProtocol = contactsViewController
            controller = contactsViewController
            
        case AppConst.TabIndex.More:
            controller=MoreViewController()
            
        default:
            fatalError()
        }
        
        return controller
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if !isUserLogedIn(),authIsMandatory(for: viewController)
            {
            showLoginVC()
            return false
        }
        
        
        return true
        
    }
    
    private func authIsMandatory(for viewController:UIViewController)->Bool {
        guard let vc = (viewController as? UINavigationController)?.viewControllers.first else {
            return false
        }
        
        if
            vc as? RegisterGiftViewController != nil
            ||
            vc as? MyWallViewController != nil
            ||
            vc as? ContactsViewController != nil
        {
            return true
        }
        
        return false
    }
    
    func setTabsDelegates(tabs:[UINavigationController]){
        
        self.tabBarPagesRelaodDelegates = []
        
        for tab in tabs {
            guard let reloadPageDelegate = tab.viewControllers.first as? ReloadablePage else {
                continue
            }
            
            if
                tab.viewControllers.first as? HomeViewController != nil
                    ||
                    tab.viewControllers.first as? MyWallViewController != nil {
                
                self.tabBarPagesRelaodDelegates.append(reloadPageDelegate)
            }
        }
    }
    
    func reloadTabBarPages(currentPage: ReloadablePage?){
        for delegate in self.tabBarPagesRelaodDelegates {
            if let currentPage=currentPage, delegate === currentPage {
                continue
            }
            delegate.reloadPage()
        }
    }
}