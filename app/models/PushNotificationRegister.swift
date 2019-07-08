//
//  PushNotificationRegister.swift
//  app
//
//  Created by Amir Hossein on 7/6/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class PushNotificationRegister: Codable {
    var deviceIdentifier: String
    var type: String
    var devicePushToken: String
    
    init(deviceIdentifier: String, devicePushToken: String) {
        self.deviceIdentifier = deviceIdentifier
        self.type = PushNotificationType.APNS.rawValue
        self.devicePushToken = devicePushToken
    }
}

enum PushNotificationType: String, Codable {
    case APNS
}
