//
//  GiftDetailVM.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftDetailVM: NSObject {
    lazy var apiService = ApiService(HTTPLayer())

    func removeGift(id: Int, completion: @escaping (Result<Void>) -> Void) {
        apiService.removeGift(id: id, completion: completion)
    }

    func requestGift(id: Int, completion: @escaping (Result<Chat>) -> Void) {
        apiService.requestGift(id: id, completion: completion)
    }

    func checkRequestStatus(id: Int, completion: @escaping (Result<GiftRequestStatus>) -> Void) {
        apiService.requestGiftStatus(id: id, completion: completion)
    }

}
