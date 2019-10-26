//
//  DonatedGiftViewModel.swift
//  app
//
//  Created by Hamed.Gh on 12/7/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class DonatedGiftViewModel: GiftViewModel {
    
    init(userId:Int) {
        super.init(giftListType: .UserDonatedGifts(userId: userId))
    }
    
}
