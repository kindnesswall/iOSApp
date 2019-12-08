//
//  City.swift
//  App
//
//  Created by Amir Hossein on 2/8/19.
//

import Foundation

final class City: Codable {
    var id: Int?
    var provinceId: Int?
    var name: String?

    init(id: Int?, name: String?) {
        self.id=id
        self.name=name
    }
}
