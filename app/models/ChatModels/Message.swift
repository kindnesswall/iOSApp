//
//  Message.swift
//  App
//
//  Created by Amir Hossein on 1/27/19.
//

import Foundation

final class Message : Codable {
    var type: MessageType
    
    var contactMessage: ContactMessage?
    var controlMessage: ControlMessage?
    
    init(contactMessage: ContactMessage) {
        self.type = .contact
        self.contactMessage=contactMessage
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
