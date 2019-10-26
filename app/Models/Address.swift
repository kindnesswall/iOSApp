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
    var provinceId:Int?
    var cityId:Int?
    
    init() {
        
    }
    
    init(address:String?,provinceId:Int?,cityId:Int?){
        self.address=address
        self.provinceId=provinceId
        self.cityId=cityId
    }
}
