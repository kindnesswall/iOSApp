//
//  Donate.swift
//  App
//
//  Created by Amir Hossein on 3/14/19.
//

import Foundation

class Donate: Codable {
    var giftId: Int
    var donatedToUserId: Int

    init(giftId: Int, donatedToUserId: Int) {
        self.giftId=giftId
        self.donatedToUserId=donatedToUserId
    }
}
