//
//  ControlMessage.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

final class ControlMessage : Codable {
    var type:ControlMessageType
    var fetchMoreMessagesInput:FetchMoreMessagesInput?
    var ackMessage:AckMessage?
    
    init(type:ControlMessageType) {
        self.type=type
    }
    init(type:ControlMessageType,fetchMoreMessagesInput:FetchMoreMessagesInput) {
        self.type = type
        self.fetchMoreMessagesInput=fetchMoreMessagesInput
    }
    init(ackMessage:AckMessage) {
        self.type = .ack
        self.ackMessage=ackMessage
    }
}

enum ControlMessageType : String,Codable {
    case ready
    case fetch
    case fetchMore
    case noMoreOldMessages
    case ack
}
