//
//  ApiInput.swift
//  app
//
//  Created by Hamed.Gh on 7/22/1396 AP.
//  Copyright © 1396 Hamed.Gh. All rights reserved.
//

import Foundation

class ApiInput {
    
    static let password:String = "password"
    static let username:String = "username"
    static let device_id:String = "device_id"
    static let giftId:String = "giftId"
    static let registeration_id:String = "registeration_id"
    
    static func LogoutInput(registeration_id:String) -> [String:String] {
        return [
            self.registeration_id:registeration_id
        ]
    }
    
    static func SetDeviceInput(registeration_id:String, device_id:String) -> [String:String] {
        return [
            self.registeration_id:registeration_id,
            self.device_id:device_id
        ]
    }
    
    static func BookmarkInput(giftId:String) -> [String:String] {
        return [
            self.giftId:giftId
        ]
    }
}

