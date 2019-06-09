//
//  GiftDetailVM.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftDetailVM: NSObject {
    lazy var apiRequest = ApiRequest(httpLayer: HTTPLayer())

    func removeGift(id:Int, completion: @escaping (Result<Void>)-> Void) {
        apiRequest.removeGift(id: id, completion: completion)
    }
    
    func requestGift(id: Int, completion: @escaping (Result<Chat>)-> Void) {
        apiRequest.requestGift(id: id,completion: completion)
    }
    
}

