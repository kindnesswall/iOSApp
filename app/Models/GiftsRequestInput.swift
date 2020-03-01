//
//  RequestInput.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

class GiftsRequestInput: Codable {
    var beforeId: Int?
    var count: Int?
    var categoryIds:[Int]?
    var countryId: Int?
    var provinceId: Int?
    var cityId: Int?

}
