//
//  Address.swift
//  app
//
//  Created by Hamed.Gh on 12/31/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class Address {
    var address:String?
    var cityId:Int?
    var regionId:Int?
    
    init() {
        
    }
    
    init(address:String?,cityId:Int?,regionId:Int?){
        self.address=address
        self.cityId=cityId
        self.regionId=regionId
    }
}
