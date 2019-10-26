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
    let tabBarViewModel = TabBarViewModel()

    lazy var tabBarCoordinator:TabBarCoordinator = TabBarCoordinator(tabBarController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarCoordinator.initializeTabs()
    }
    
    func refreshAppAfterSwitchUser(){
        tabBarCoordinator.refreshAppAfterSwitchUser()
    }
    
    func logout(){
        AppDelegate.me().appViewModel.clearUserSensitiveData()
        tabBarCoordinator.refreshAppAfterSwitchUser()
    }
    
    func checkForLogin()->Bool{
        if AppDelegate.me().appViewModel.isUserLogedIn() {
            return true
        }
        tabBarCoordinator.showLoginView()
        return false
    }
}

extension TabBarController : UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if !AppDelegate.me().appViewModel.isUserLogedIn(),tabBarViewModel.isAuthenticationMandatory(for: viewController)
            {
                tabBarCoordinator.showLoginView()
            return false
        }
        
        return true
        
    }
    
}
