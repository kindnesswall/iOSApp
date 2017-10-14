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
    static let registeration_id:String = "registeration_id"
    
    static func isUserPassCorrectInput(username:String, password:String, registeration_id:String, device_id:String) -> [String:String] {
        return [
            self.username:username,
            self.password:password,
            self.registeration_id:registeration_id,
            self.device_id:device_id
        ]
    }
}

