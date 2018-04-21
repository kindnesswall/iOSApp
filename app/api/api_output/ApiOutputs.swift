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

class StatisticsOutput: Codable {
    var statistics:[String:String]?
}

class RegisterOutput: Codable {
    var remainingSeconds:String?
}

class TokenOutput: Codable {
    var access_token:String?
    var userName:String?
    var userId:String?
    var error:String?
}

enum TokenOutputError:String {
    case invalid_grant="invalid_grant"
}
