//
//  ControlMessage.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

final class ControlMessage : Codable {
    var type:ControlMessageType
    var fetchMessagesInput:FetchMessagesInput?
    var ackMessage:AckMessage?
    
    init(type:ControlMessageType) {
        self.type=type
    }
    init(type:ControlMessageType,fetchMessagesInput:FetchMessagesInput) {
        self.type = type
        self.fetchMessagesInput=fetchMessagesInput
    }
    init(ackMessage:AckMessage) {
        self.type = .ack
        self.ackMessage=ackMessage
    }
}

enum ControlMessageType : String,Codable {
    case ready
    case fetchContact
    case fetchMessage
    case noMoreOldMessages
    case ack
}
