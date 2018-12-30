//
//  Urls.swift
//  SwiftMessenger
//
//  Created by Hamed.Gh on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation


struct Const {
    
    struct Resources {
        
    }
    
    struct Urls {
        static let IMAGES:String = "ios_profile_images"
        static let USERS:String = "ios_users"
        static let MESSAGES:String = "ios_messages"
        static let USER_MESSAGES:String = "ios_user_messages"
        static let MESSAGES_MOVIE:String = "ios_message_movies"
        static let MESSAGES_IMAGE:String = "ios_message_images"
    }
    
    struct Keys {
        struct User {
            static let NAME:String = "name"
            static let EMAIL:String = "email"
            static let PROFILE_IMG_URL:String = "profileImageURL"
            static let ID:String = "id"
        }
        
        struct Message {
            static let FromID:String = "fromId"
            static let TEXT:String = "text"
            static let ToID:String = "toId"
            static let TimeStamp:String = "timestamp"
            
            static let ImageUrl:String = "imageUrl"
            static let VideoUrl:String = "videoUrl"
            static let ImageWidth:String = "imageWidth"
            static let ImageHeight:String = "imageHeight"
        }
    }
    
    struct DateFormat {
        static let TIME:String = "hh:mm:ss a"
    }
}




