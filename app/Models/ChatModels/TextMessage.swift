//
//  TextMessage.swift
//  App
//
//  Created by Amir Hossein on 1/28/19.
//

import Foundation

final class TextMessage: Codable {
    var id: Int?
    var chatId: Int
    var senderId: Int
    var receiverId: Int?
    var text: String
    var ack: Bool?
    var createdAt: String?

    var sendingState: MessageSendingState?
    var hasSeen: Bool?
    private(set) var isNewMessage: Bool? = false
    var isFirstNewMessage: Bool? = false

    init(text: String, senderId: Int, chatId: Int) {
        self.text=text
        self.senderId=senderId
        self.chatId=chatId
        self.sendingState = .sending
    }

    func updateIsNewMessage(userId: Int) {
        self.isNewMessage = isNewMessage(userId: userId)
    }

    private func isNewMessage(userId: Int) -> Bool {
        if self.receiverId == userId, !(self.ack == true), !(self.hasSeen == true) {
            return true
        }
        return false
    }
}
