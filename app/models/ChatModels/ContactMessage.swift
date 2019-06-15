//
//  ContactMessage.swift
//  App
//
//  Created by Amir Hossein on 5/22/19.
//

import Foundation


class ContactMessage: Codable {
    var chat: Chat?
    var contactInfo: UserProfile?
    var textMessages: [TextMessage]?
    var notificationCount: Int?
    
    init(textMessages: [TextMessage]?) {
        self.textMessages = textMessages
    }
}
