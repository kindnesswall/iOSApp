//
//  KeychainService.swift
//  app
//
//  Created by Hamed Ghadirian on 08.12.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

enum KeychainKey {
    case deviceIdentifier
    case pushToken
    case passCode
    case authorization
    case isAdmin
    case isCharity
    case userId
}

class KeychainService {
    private let keychain = KeychainSwift()

    func clearUserSensitiveData() {
        delete(.userId)
        delete(.isAdmin)
        delete(.authorization)
        delete(.passCode)
    }

    func set(_ authOutput: AuthOutput) {
        if let userID = authOutput.token.userID?.description, let token = authOutput.token.token {

            keychain.set(userID, forKey: AppConst.KeyChain.UserID)
            keychain.set(AppConst.KeyChain.BEARER + " " + token, forKey: AppConst.KeyChain.Authorization)
        }

        keychain.set(authOutput.isAdmin, forKey: AppConst.KeyChain.IsAdmin)
        keychain.set(authOutput.isCharity, forKey: AppConst.KeyChain.IsCharity)
    }
    
    func isUserLogedIn() -> Bool {
        return get(.authorization) != nil
    }
    
    public func isPasscodeSaved() -> Bool {
        return get(.passCode) != nil
    }
    
    func isAdmin() -> Bool {
        return keychain.getBool(AppConst.KeyChain.IsAdmin) ?? false
    }
    
    func isCharity() -> Bool {
        return keychain.getBool(AppConst.KeyChain.IsCharity) ?? false
    }
    
    func set(_ key: KeychainKey, value: String) {
        switch key {
        case .deviceIdentifier:
            keychain.set(value, forKey: AppConst.KeyChain.DeviceIdentifier)
        case .pushToken:
            keychain.set(value, forKey: AppConst.KeyChain.PushToken)
        case .passCode:
            keychain.set(value, forKey: AppConst.KeyChain.PassCode)
        case .authorization:
            keychain.set(value, forKey: AppConst.KeyChain.Authorization)
        case .userId:
            keychain.set(value, forKey: AppConst.KeyChain.UserID)
        default:
            return
        }
    }
    
    func set(_ key: KeychainKey, value: Bool) {
        switch key {
        case .isCharity:
            keychain.set(value, forKey: AppConst.KeyChain.IsCharity)
        case .isAdmin:
            keychain.set(value, forKey: AppConst.KeyChain.IsAdmin)
        default:
            return
        }
    }
    
    func delete(_ key: KeychainKey) {
        switch key {
        case .deviceIdentifier:
            keychain.delete(AppConst.KeyChain.DeviceIdentifier)
        case .pushToken:
            keychain.delete(AppConst.KeyChain.PushToken)
        case .passCode:
            keychain.delete(AppConst.KeyChain.PassCode)
        case .authorization:
            keychain.delete(AppConst.KeyChain.Authorization)
        case .isAdmin:
            keychain.delete(AppConst.KeyChain.IsAdmin)
        case .userId:
            keychain.delete(AppConst.KeyChain.UserID)
        case .isCharity:
            keychain.delete(AppConst.KeyChain.IsCharity)
        }
    }
    
    func get(_ key: KeychainKey) -> String? {
        switch key {
        case .deviceIdentifier:
            return keychain.get(AppConst.KeyChain.DeviceIdentifier)
        case .pushToken:
            return keychain.get(AppConst.KeyChain.PushToken)
        case .passCode:
            return keychain.get(AppConst.KeyChain.PassCode)
        case .authorization:
            return keychain.get(AppConst.KeyChain.Authorization)
        default:
            return nil
        }
    }
    
    func clear() {
        keychain.clear()
    }
    
}
