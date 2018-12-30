//
//  AppConst.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

struct AppConst {
    
    struct Resource {
        struct Font {
            static func getRegularFont(size:CGFloat)->UIFont {
                return UIFont(name: "IRANSansMobile", size: size)!
            }
            static func getLightFont(size:CGFloat)->UIFont {
                return UIFont(name: "IRANSansMobile-Light", size: size)!
            }
            static func getBoldFont(size:CGFloat)->UIFont {
                return UIFont(name: "IRANSansMobile-Bold", size: size)!
            }
            
            static func getIcomoonFont(size:CGFloat)->UIFont {
                return UIFont(name: "icomoon" , size:size)!
            }
        }
        
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
        public static let PassCode:String = "PassCode"
    }
    
    struct UserDefaults {
        static let RegisterGiftDraft="RegisterGiftDraft"
        public static let PHONE_NUMBER:String = "PHONE_NUMBER"
        public static let WATCHED_INTRO:String = "watched_intro"
        public static let WATCHED_SELECT_LANGUAGE:String = "WATCHED_SELECT_LANGUAGE"
        public static let FirstInstall:String = "FirstInstall"
        public static let LastTimeISawAd:String = "LastTimeISawAd"
        static let AppleLanguages:String = "AppleLanguages"
    }
    
    struct APIMethodDictionaryKey {
        static let Username:String = "username"
        static let Password:String = "password"
        static let DeviceId:String = "deviceId"
        static let RegisterationId:String = "registerationId"
    }
    
    struct TabIndex {
        //    public static let CHAT:Int = 4
        public static let HOME:Int = 4
        public static let MyGifts:Int = 3
        public static let RegisterGift:Int = 2
        public static let Requests:Int = 1
        public static let MyKindnessWall:Int = 0
        
    }
}



