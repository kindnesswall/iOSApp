//
//  RequestInput.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

enum GiftListType {
    case Gifts
    case Review
    case Donated(userId:Int)
    case Received(userId:Int)
    case registered(userId:Int)
    case ToDonate(toUserId:Int)
    
    var path:String{
        switch self {
        case .Review:
            return "/gifts/review"
        case .Donated(let userId):
            return "/gifts/userDonated/\(userId)"
        case .Received(let userId):
            return "/gifts/userReceived/\(userId)"
        case .registered(let userId):
            return "/gifts/userRegistered/\(userId)"
        case .Gifts:
            return "/gifts/"
        case .ToDonate(let toUserId):
            return "/gifts/todonate/\(toUserId)"
        }
    }
}

struct GiftListRequestParameters {
    var input:RequestInput
    var type:GiftListType
}

class RequestInput: Codable {
    var beforeId:Int?
    var count:Int?
    var categoryId:Int?
    var provinceId:Int?
    var cityId:Int?
    
    init(beforeId:Int, count:Int) {
        self.beforeId = beforeId
        self.count = count
    }
    init() {
        
    }
}
