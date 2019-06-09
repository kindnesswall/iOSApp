//
//  RegisteredGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class RegisteredGiftViewModel: GiftViewModel {
    
    init() {
        let url=URIs().gifts_review //gifts_owner
        super.init(url: url)
    }
}
