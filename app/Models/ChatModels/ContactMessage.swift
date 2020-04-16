//
//  ContactMessage.swift
//  App
//
//  Created by Amir Hossein on 5/22/19.
//

import Foundation

class ContactMessage: Codable {
    var chat: ChatContacts?
    var contactProfile: UserProfile?
    var textMessages: [TextMessage]?
    var notificationCount: Int?
    var blockStatus: BlockStatus?
}

final class BlockStatus: Codable {
    var userIsBlocked: Bool?
    var contactIsBlocked: Bool?
}

enum BlockCase {
    case block
    case unblock
}
