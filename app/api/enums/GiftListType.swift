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
