//
//  MessageSendingState.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/12/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation

enum MessageSendingState :String,Codable{
    case sending
    case sent
    case failed
}
