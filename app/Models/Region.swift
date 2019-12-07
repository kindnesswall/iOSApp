//
//  Region.swift
//  app
//
//  Created by Hamed Ghadirian on 03.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class Region:Codable {
    var id:Int?
    var cityId:Int
    var name:String
    var latitude:Double
    var longitude:Double
    var sortIndex:Int?
}
