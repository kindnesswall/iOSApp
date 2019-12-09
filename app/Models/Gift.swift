//
//  Gift.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

protocol GiftPresenter {
    var title: String? { get }
    var createdAt: String? { get }
    var description: String? { get }
    var giftImages: [String]? { get }

    var provinceName: String? { get }
    var cityName: String? { get }
    var regionName: String? { get }
}

protocol RegisterGiftInput {
    var title: String? { get set }
    var description: String? { get set }
    var giftImages: [String]? { get set }
    var price: Int? { get set }
    var categoryId: Int? { get set }
    var isNew: Bool? { get set }
    var provinceId: Int? { get set }
    var cityId: Int? { get set }
}

class Gift: Codable, GiftPresenter, RegisterGiftInput {

    var id: Int?
    var userId: Int?
    var donatedToUserId: Int?
    var isReviewed: Bool?
    var isRejected: Bool?
    var isDeleted: Bool?
    var categoryTitle: String?

    var title: String?
    var description: String?
    var price: Int?
    var categoryId: Int?
    var giftImages: [String]?
    var isNew: Bool?
    var provinceId: Int?
    var cityId: Int?
    var regionId: Int?
    var provinceName: String?
    var cityName: String?
    var regionName: String?

    var createdAt: String?
    var updatedAt: String?
    var deletedAt: String?
}
