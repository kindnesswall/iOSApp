//
//  MainTabBarController.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class MainTabBarController : NSObject{
    public var tabBarController:UITabBarController?
    weak var startNewChatProtocol:StartNewChatProtocol?
    weak var refreshChatProtocol:RefreshChatProtocol?
    let keychain = KeychainSwift()
    var tabBarPagesRelaodDelegates = [ReloadablePage]()

    override init() {
        super.init()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        self.tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController
        self.tabBarController?.delegate=self
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
        
        initiateTab(tabIndex: AppConst.TabIndex.Charities,tabs:tabs)
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


