//
//  Gift.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class Gift: Codable {
    var requestCount:String?
    var title:String?
    var address:String?
    var bookmark:Bool?
    var description:String?
    var price:String?
    var status:String?
    var userId:String?
    var user:String?
    var receivedUserId:String?
    var receivedUser:String?
    var categoryId:String?
    var category:String?
    var cityId:String?
    var location:String?
    var regionId:String?
    var region:String?
    var giftImages:[String]?
    var id:String?
    var createDateTime:String?
    var createDate:String?
    var createTime:String?
    var isNew:Bool?
    var forWho:Int?
}
