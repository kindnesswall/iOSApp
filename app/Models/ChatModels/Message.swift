//
//  Message.swift
//  App
//
//  Created by Amir Hossein on 1/27/19.
//

import Foundation

final class Message : Codable {
    var type: MessageType
    
    var contactMessages: [ContactMessage]?
    var controlMessage: ControlMessage?
    
    init(contactMessages: [ContactMessage]) {
        self.type = .contact
        self.contactMessages=contactMessages
    }
    init(controlMessage: ControlMessage) {
        self.type = .control
        self.controlMessage=controlMessage
    }
}

enum MessageType : String,Codable {
    case contact
    case control
}
