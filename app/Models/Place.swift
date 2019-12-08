//
//  Place.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class Place: Codable {

    var id: Int?
    var name: String?
    var containerId: Int?

    init() {

    }

    init(id: Int?, name: String?) {
        self.id=id
        self.name=name
    }
    init(id: Int?, name: String?, containerId: Int?) {
        self.id=id
        self.name=name
        self.containerId=containerId
    }
}

class PlaceResponse: Codable {
    var places: [Place]?

}
