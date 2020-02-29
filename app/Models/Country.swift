//
//  Country.swift
//  app
//
//  Created by Amir Hossein on 2/27/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import Foundation

class Country: Codable {
    var id:Int?
    var name:String
    var phoneCode: String?
    var localization: String?
    var sortIndex:Int?
    
    var isFarsi: Bool {
        return localization == "fa"
    }
}
