//
//  ApiOutputs.swift
//  app
//
//  Created by Hamed.Gh on 10/27/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class AppInfoOutput: Codable {
    var smsCenter:String?
}

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
}

class RequestModel: Codable {
    
    var giftId:String?
    var gift:String?
    
    var fromUserId:String?
    var fromUser:String?
    
    var toUserId:String?
    var toUser:String?
    
    var toStatus:String?
}

class StatisticsOutput: Codable {
    var statistics:[String:String]?
}

class User: Codable {
    var userName:String?
    var id:String?
}

class Category: Codable {
    var imageUrl:String?
    var title:String?
    
    var id:String?
    var createDateTime:String?
    var createDate:String?
    var createTime:String?
}
