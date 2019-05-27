//
//  Profile.swift
//  App
//
//  Created by Amir Hossein on 5/27/19.
//

import Foundation

final class UserProfile : Codable {
    var name:String?
    var image:String?
    
    init() {}
    
    init(name:String?,image:String?) {
        self.name=name
        self.image=image
    }
}



