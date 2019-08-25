//
//  PushRegisterInput.swift
//  app
//
//  Created by Hamed Ghadirian on 25.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

final class PushRegisterInput : Codable {
    var type:String = "APNS"
    var devicePushToken:String
    var deviceIdentifier:String
    
    init(_ devicePushToken:String,_ deviceIdentifier:String) {
        self.devicePushToken = devicePushToken
        self.deviceIdentifier = deviceIdentifier
    }
}
