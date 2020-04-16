//
//  GiftDetailVM.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftDetailVM: NSObject {
    let keychainService = KeychainService()
    
    lazy var apiService = ApiService(HTTPLayer())

    func isItMy(userId: Int?) -> Bool {
        guard let userId = userId else {
            return false
        }
        if let myIdString=keychainService.getString(.userId), let myId=Int(myIdString), myId==userId {
            return true
        }
        return false
    }
    
    func isUserLogedIn() -> Bool {
        return keychainService.isUserLogedIn()
    }
    
    func removeGift(id: Int, completion: @escaping (Result<Void>) -> Void) {
        apiService.removeGift(id: id, completion: completion)
    }

    func requestGift(id: Int, completion: @escaping (Result<ChatContacts>) -> Void) {
        apiService.requestGift(id: id, completion: completion)
    }

    func checkRequestStatus(id: Int, completion: @escaping (Result<GiftRequestStatus>) -> Void) {
        apiService.requestGiftStatus(id: id, completion: completion)
    }

}
