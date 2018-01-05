//
//  ChatAbs.swift
//  VC
//
//  Created by maede on 10/16/17.
//  Copyright © 2017 Aseman. All rights reserved.
//

import Foundation
import UIKit

class ChatAbs:Codable {
    var chat_id:Int?
    var user_id:Int?
    var last_message:Message?
    var count_unseen:Int?
}
