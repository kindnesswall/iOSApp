//
//  Request Inputs.swift
//  app
//
//  Created by AmirHossein on 3/22/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation


class RegisterGiftInput : Codable {
    var title:String?
    var address:String?
    var description:String?
    var price:Int?
    var categoryId:Int?
    var cityId:Int?
    var regionId:Int?
    var giftImages : [String]?
}
