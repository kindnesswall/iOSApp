//
//  ReceivedGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 5/20/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class ReceivedGiftViewModel: GiftViewModel {
    
    init() {
        let url=URIs().gifts_received
        super.init(url: url)
    }
    
}
