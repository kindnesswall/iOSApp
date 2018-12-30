//
//  FirebaseUser.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class FirebaseUser: Codable {
    var id:String?
    var email:String?
    var name:String?
    var profileImageURL:String?
    
//    init(dictionary: [String: Any]) {
//        self.name = dictionary[Const.Keys.User.NAME] as? String
//        self.email = dictionary[Const.Keys.User.EMAIL] as? String
//        self.profileImageURL = dictionary[Const.Keys.User.PROFILE_IMG_URL] as? String
//    }
}
