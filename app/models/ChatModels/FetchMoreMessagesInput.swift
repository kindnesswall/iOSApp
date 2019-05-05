//
//  FetchMoreMessagesInput.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

class FetchMoreMessagesInput: Codable {
    var chatId:Int
    var beforeId:Int?
    
    init(chatId:Int,beforeId:Int?) {
        self.chatId=chatId
        self.beforeId=beforeId
    }
}
