//
//  SendMessageInput.swift
//  app
//
//  Created by Hamed Ghadirian on 29.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
struct SendMessageInput:Codable {
    var chatId:Int
    var text:String
}
