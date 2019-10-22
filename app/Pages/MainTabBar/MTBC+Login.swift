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

extension MainTabBarController {
    func login(userID:String,token:String,isAdmin:Bool,isCharity:Bool){
        let keychain = KeychainSwift()
        
        keychain.set(userID, forKey: AppConst.KeyChain.USER_ID)
        keychain.set(AppConst.KeyChain.BEARER + " " + token, forKey: AppConst.KeyChain.Authorization)
        keychain.set(isAdmin, forKey: AppConst.KeyChain.IsAdmin)
        keychain.set(isCharity, forKey: AppConst.KeyChain.IsCharity)
        
        AppDelegate.me().registerPush()
        resetAppAfterSwitchUser()
    }
    
    func logout(){
        let keychain = KeychainSwift()
        
        keychain.delete(AppConst.KeyChain.USER_ID)
        keychain.delete(AppConst.KeyChain.Authorization)
        keychain.delete(AppConst.KeyChain.IsAdmin)
        
        resetAppAfterSwitchUser()
    }
    
    
    func showLoginVC(){
        let controller=LoginRegisterViewController()
        
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)
    }
    
    func isUserLogedIn() -> Bool {
        
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            return true
        }
        return false
    }
    
    func checkForLogin()->Bool{
        if isUserLogedIn() {
            return true
        }
        showLoginVC()
        return false
    }
}
