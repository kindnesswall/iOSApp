//
//  TextMessage.swift
//  App
//
//  Created by Amir Hossein on 1/28/19.
//

import Foundation


final class TextMessage : Codable {
    var id:Int?
    var chatId:Int
    var senderId:Int
    var receiverId:Int?
    var text:String
    var ack:Bool?
    var createdAt:Date?
    
    var sendingState:MessageSendingState?
    var hasSeen:Bool?
    
    init(text:String,senderId:Int,chatId:Int) {
        self.text=text
        self.senderId=senderId
        self.chatId=chatId
        self.sendingState = .sending
    }
}