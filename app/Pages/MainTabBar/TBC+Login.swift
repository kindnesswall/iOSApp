//
//  MTBC+Login.swift
//  app
//
//  Created by Hamed Ghadirian on 22.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift
import UIKit

extension TabBarController {
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
