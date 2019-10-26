//
//  TabBarCoordinator.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class TabBarCoordinator {
    
    let home = HomeCoordinator()
    let charities = CharitiesCoordinator()
    let donateGiftCoordinator = DonateGiftCoordinator()
    
    var moreCoordinator = MoreCoordinator()
    var chatCoordinator = ChatCoordinator()

    var tabBarPagesRelaodDelegates = [ReloadablePage]()

    let tabBarController:UITabBarController
//    let appCoordinator: AppCoordinator
    init(tabBarController:UITabBarController) {
//        self.appCoordinator = AppDelegate.me().appCoordinator
        self.tabBarController = tabBarController
    }
    
    func showLoginView() {
        AppDelegate.me().appCoordinator.showLoginVC()
    }
    
    func initializeTabs()  {
        var tabs = [UIViewController](repeating: UIViewController(), count: 5)
        tabs[AppConst.TabIndex.HOME] = home.navigationController
        tabs[AppConst.TabIndex.Charities] = charities.navigationController
        tabs[AppConst.TabIndex.RegisterGift] = donateGiftCoordinator.navigationController
        tabs[AppConst.TabIndex.Chat] = chatCoordinator.navigationController
        tabs[AppConst.TabIndex.More] = moreCoordinator.navigationController
        
        self.tabBarController.viewControllers = tabs
        
        setTabsDelegates()

        self.tabBarController.tabBarController?.selectedIndex = AppConst.TabIndex.HOME
    }
    
    func refreshAppAfterSwitchUser(){
        chatCoordinator = ChatCoordinator()
        let chatNC = chatCoordinator.navigationController
        _ = chatNC.view
        self.tabBarController.viewControllers?[AppConst.TabIndex.Chat] = chatNC
        
        moreCoordinator = MoreCoordinator()
        let moreNC = moreCoordinator.navigationController
        _ = moreNC.view
        self.tabBarController.viewControllers?[AppConst.TabIndex.More] = moreNC
    }

    func setTabsDelegates(){
        guard let tabs = self.tabBarController.viewControllers as? [UINavigationController] else { return }

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
