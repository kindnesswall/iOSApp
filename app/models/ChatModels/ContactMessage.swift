//
//  ContactMessage.swift
//  App
//
//  Created by Amir Hossein on 5/22/19.
//

import Foundation


class ContactMessage: Codable {
    var chat: Chat?
    var contactInfo: ContactInfo?
    var textMessages: [TextMessage]?
    init(textMessages: [TextMessage]?) {
        self.textMessages = textMessages
    }
}

class ContactInfo: Codable {
    var id: Int
    var name: String?
    var image: String?
    
    init(id: Int,name: String?,image: String?) {
        self.id=id
        self.name=name
        self.image=image
    }
}
