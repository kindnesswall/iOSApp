//
//  GiftListType.swift
//  app
//
//  Created by Hamed Ghadirian on 25.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum GiftListType {
    case UserDonatedGifts(userId:Int)
    case UserReceivedGifts(userId:Int)
    case UserRegisteredGifts(userId:Int)
    case GiftsToDonate(toUserId:Int)
}
