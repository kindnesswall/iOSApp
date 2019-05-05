//
//  AckMessage.swift
//  App
//
//  Created by Amir Hossein on 3/11/19.
//

import Foundation

class AckMessage: Codable {
    var messageId:Int
    var textMessage:TextMessage?
    
    init(messageId:Int) {
        self.messageId=messageId
    }
    init?(textMessage:TextMessage) {
        guard let messageId = textMessage.id else {
            return nil
        }
        self.messageId=messageId
        self.textMessage=textMessage
    }
}
