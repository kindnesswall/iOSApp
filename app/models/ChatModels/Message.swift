//
//  Message.swift
//  App
//
//  Created by Amir Hossein on 1/27/19.
//

import Foundation

final class Message : Codable {
    var type: MessageType
    
    var textMessages: [TextMessage]?
    var controlMessage: ControlMessage?
    
    init(controlMessage: ControlMessage) {
        self.type = .control
        self.controlMessage=controlMessage
    }
    
    init(textMessages: [TextMessage]) {
        self.type = .text
        self.textMessages=textMessages
    }
}

enum MessageType : String,Codable {
    case text
    case control
}
