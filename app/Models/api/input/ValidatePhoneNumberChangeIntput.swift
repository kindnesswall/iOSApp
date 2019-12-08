//
//  ValidatePhoneNumberChangeIntput.swift
//  app
//
//  Created by Hamed Ghadirian on 03.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class ValidatePhoneNumberChangeIntput: Codable {
    var phoneNumber: String
    var activationCode: String

    init(phoneNumber: String, activationCode: String) {
        self.phoneNumber = phoneNumber
        self.activationCode = activationCode
    }
}
