//
//  AppConst.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

struct AppConst {
    
    struct Resources {
        
    }
    
    struct FIRUrls {
        static let IMAGES:String = "ios_profile_images"
        static let USERS:String = "ios_users"
        static let MESSAGES:String = "ios_messages"
        static let USER_MESSAGES:String = "ios_user_messages"
        static let MESSAGES_MOVIE:String = "ios_message_movies"
        static let MESSAGES_IMAGE:String = "ios_message_images"
    }
    
    struct KeyChain {
        static let Authorization:String = "Authorization"
        public static let USER_NAME:String = "USER_NAME"
        public static let USER_ID:String = "USER_ID"
        public static let BEARER:String = "bearer"
    }
    
    struct UserDefaults {
        static let RegisterGiftDraft="RegisterGiftDraft"
        public static let PHONE_NUMBER:String = "PHONE_NUMBER"
    }
    
    static let AppleLanguages:String = "AppleLanguages"
    public static let WATCHED_INTRO:String = "watched_intro"
    public static let WATCHED_SELECT_LANGUAGE:String = "WATCHED_SELECT_LANGUAGE"

    public static let LastViewdUpdateVersion:String = "LastViewdUpdateVersion"
    
    static let ContentType:String = "content-type"

    public static let LastTimeISawAd:String = "LastTimeISawAd"
    
    public static let PassCode:String = "PassCode"
    public static let FirstInstall:String = "FirstInstall"
}

struct APIMethodDictionaryKey {
    static let Username:String = "username"
    static let Password:String = "password"
    static let DeviceId:String = "deviceId"
    static let RegisterationId:String = "registerationId"
}

