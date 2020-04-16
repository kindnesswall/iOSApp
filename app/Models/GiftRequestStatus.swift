//
//  GiftRequestStatus.swift
//  App
//
//  Created by Amir Hossein on 10/31/19.
//

import Foundation

final class GiftRequestStatus: Codable {
    var isRequested: Bool
    var chat: ChatContacts?
}
