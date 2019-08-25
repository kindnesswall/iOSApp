//
//  RequestInput.swift
//  App
//
//  Created by Amir Hossein on 1/29/19.
//

import Foundation

struct GiftListRequestParameters {
    var input:RequestInput
    var type:GiftListType
}

class RequestInput: Codable {
    var beforeId:Int?
    var count:Int?
    var categoryId:Int?
    var provinceId:Int?
    var cityId:Int?
    
    init(beforeId:Int, count:Int) {
        self.beforeId = beforeId
        self.count = count
    }
    
    init() {
        
    }
}
