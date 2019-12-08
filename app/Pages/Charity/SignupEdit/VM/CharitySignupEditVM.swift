//
//  CharitySignupEditVM.swift
//  app
//
//  Created by Hamed Ghadirian on 31.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class CharitySignupEditVM: UploadImageVM {
    var charity: Charity?
    init(charity: Charity) {
        self.charity = charity
    }
    override init() {
        super.init()
    }
}
