//
//  ReceivedGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 5/20/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class ReceivedGiftViewModel: GiftViewModel {
    
    init(userId:Int) {
        super.init(giftListType: .Received(userId: userId))
    }
    
}
