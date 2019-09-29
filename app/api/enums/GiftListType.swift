//
//  GiftListType.swift
//  app
//
//  Created by Hamed Ghadirian on 25.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum GiftListType {
    case Gifts
    case Review
    case Donated(userId:Int)
    case Received(userId:Int)
    case registered(userId:Int)
    case ToDonate(toUserId:Int)
    
    var giftBasePathUrl:String{ return "/gifts/" }
    
    var path:String{
        switch self {
        case .Review:
            return giftBasePathUrl + "review"
        case .Donated(let userId):
            return giftBasePathUrl + "userDonated/\(userId)"
        case .Received(let userId):
            return giftBasePathUrl + "userReceived/\(userId)"
        case .registered(let userId):
            return giftBasePathUrl + "userRegistered/\(userId)"
        case .Gifts:
            return giftBasePathUrl
        case .ToDonate(let toUserId):
            return giftBasePathUrl + "todonate/\(toUserId)"
        }
    }
}
