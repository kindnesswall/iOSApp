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
    
    var basePathUrl:String{ return "/gifts/" }
    
    var path:String{
        switch self {
        case .Review:
            return basePathUrl + "review"
        case .Donated(let userId):
            return basePathUrl + "userDonated/\(userId)"
        case .Received(let userId):
            return basePathUrl + "userReceived/\(userId)"
        case .registered(let userId):
            return basePathUrl + "userRegistered/\(userId)"
        case .Gifts:
            return basePathUrl
        case .ToDonate(let toUserId):
            return basePathUrl + "todonate/\(toUserId)"
        }
    }
}
