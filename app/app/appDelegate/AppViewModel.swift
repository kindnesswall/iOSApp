//
//  AppViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

class AppViewModel {
    let keychain = KeychainSwift()

    func saveToKeychain(_ authOutput:AuthOutput) {
        if let userID = authOutput.token.userID?.description, let token = authOutput.token.token {
            
            keychain.set(userID, forKey: AppConst.KeyChain.USER_ID)
            keychain.set(AppConst.KeyChain.BEARER + " " + token, forKey: AppConst.KeyChain.Authorization)
        }
        
        
        keychain.set(authOutput.isAdmin, forKey: AppConst.KeyChain.IsAdmin)
        keychain.set(authOutput.isCharity, forKey: AppConst.KeyChain.IsCharity)
    }
    
    func clearUserSensitiveData() {
        let keychain = KeychainSwift()
        
        keychain.delete(AppConst.KeyChain.USER_ID)
        keychain.delete(AppConst.KeyChain.Authorization)
        keychain.delete(AppConst.KeyChain.IsAdmin)
    }
    
    func isUserLogedIn() -> Bool {
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            return true
        }
        return false
    }
}
