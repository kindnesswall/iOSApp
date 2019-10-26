//
//  User.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class User: Codable {
    
    var phoneNumber:String
    var activationCode:String?
    
    init(phoneNumber:String) {
        self.phoneNumber=phoneNumber
    }
    
    init(phoneNumber:String,activationCode:String) {
        self.phoneNumber = phoneNumber
        self.activationCode = activationCode
    }
}

class Token: Codable {
    var userID:Int?
    var token:String?
}

