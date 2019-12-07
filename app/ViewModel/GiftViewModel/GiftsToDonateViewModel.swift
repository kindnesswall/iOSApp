//
//  GiftsToDonateViewModel.swift
//  app
//
//  Created by Amir Hossein on 5/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftsToDonateViewModel: GiftViewModel {
    
    init(toUserId:Int) {
        super.init(giftListType: .giftsToDonate(toUserId: toUserId))
    }
}
