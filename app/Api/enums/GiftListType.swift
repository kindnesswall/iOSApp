//
//  GiftListType.swift
//  app
//
//  Created by Hamed Ghadirian on 25.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum GiftListType {
    case userDonatedGifts(userId:Int)
    case userReceivedGifts(userId:Int)
    case userRegisteredGifts(userId:Int)
    case giftsToDonate(toUserId:Int)
}
