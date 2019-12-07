//
//  Profile.swift
//  App
//
//  Created by Amir Hossein on 5/27/19.
//

import Foundation

final class UserProfile : Codable {
    var id: Int
    var name:String?
    var image:String?
    var phoneNumber:String?
    var isCharity:Bool?
    
    final class Input: Codable {
        var name:String?
        var image:String?
        
        init(name:String?,image:String?) {
            self.name=name
            self.image=image
        }
    }
}



