//
//  Request.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class Request: Codable {
    var giftId:String?
    var gift:String?
    
    var fromUserId:String?
    var fromUser:String?
    
    var toUserId:String?
    var toUser:String?
    
    var toStatus:String?
}
