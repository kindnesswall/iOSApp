//
//  SendPushInput.swift
//  app
//
//  Created by Hamed Ghadirian on 25.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

final class SendPushInput : Codable {
    var userId:Int
    var body:String
    
    init(userId:Int,body:String) {
        self.userId = userId
        self.body = body
    }
}

