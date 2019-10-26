//
//  TabBarController.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class TabBarController : UITabBarController{
    weak var startNewChatProtocol:StartNewChatProtocol?
    weak var refreshChatProtocol:RefreshChatProtocol?
    let keychain = KeychainSwift()
    var tabBarPagesRelaodDelegates = [ReloadablePage]()
    
    let home = HomeCoordinator()
    let charities = CharitiesCoordinator()
    let moreCoordinator = MoreCoordinator()
    let donateGiftCoordinator = DonateGiftCoordinator()
    let chatCoordinator = ChatCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTabs()
    }
    
    func initializeTabs()  {
        viewControllers = [home.navigationController,
                    charities.navigationController,
                    donateGiftCoordinator.navigationController,
                    chatCoordinator.navigationController,
                    moreCoordinator.navigationController]
        
        setTabsDelegates()

        self.tabBarController?.selectedIndex = AppConst.TabIndex.HOME

    }
    
    func resetAppAfterSwitchUser(){
        initiateTab(tabIndex: AppConst.TabIndex.Charities)
        initiateTab(tabIndex: AppConst.TabIndex.Chat)
    }
    
    func initiateTab(tabIndex:Int) {
        guard let tabs = self.viewControllers as? [UINavigationController] else { return }
        tabs[tabIndex].setViewControllers([getTabViewController(tabIndex:tabIndex)], animated: false)
    }

    func getTabViewController(tabIndex:Int)->UIViewController{
        switch tabIndex {
        case AppConst.TabIndex.HOME:
            return home.navigationController
        case AppConst.TabIndex.Charities:
            return charities.navigationController
        case AppConst.TabIndex.RegisterGift:
            return donateGiftCoordinator.navigationController
        case AppConst.TabIndex.Chat:
            return chatCoordinator.navigationController
        case AppConst.TabIndex.More:
            return moreCoordinator.navigationController
        default:
            fatalError()
        }
    }
    
    func setTabsDelegates(){
        guard let tabs = self.viewControllers as? [UINavigationController] else { return }

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


