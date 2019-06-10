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
    case Donated
    case Received
    case Owner
    case ToDonate(toUserId:Int)
    
    var path:String{
        switch self {
        case .Review:
            return "/gifts/review"
        case .Donated:
            return "/gifts/donated"
        case .Received:
            return "/gifts/received"
        case .Owner:
            return "/gifts/owner"
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
