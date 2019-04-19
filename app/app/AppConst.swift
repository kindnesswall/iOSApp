//
//  AppConst.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

struct AppConst {
    
    struct Country {
        static let IRAN:String = "Iran"
        static let OTHERS:String = "Others"
    }
    
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
        struct Color {
            static let Tint=UIColor(named: "TintColor")!
            static let GreyBg=UIColor(named:"GrayBackgroundColor")!
        }
        struct Image {
            static let Blank_Avatar:String = "blank_avatar"
        }
    }
    
    struct FIR {
        
        static let KindnessWall:String = "kindnesswall"
        
        struct Storage {
            static let Profile_Images:String = "profile_images"
            static let Gift_Images:String = "gift_images"
        }
        
        struct Database {
            static let Users:String = "Users"
            static let Gifts:String = "Gifts"
            static let Gifts_Images:String = "Gifts_Images"
            static let Users_Gifts:String = "Users_Gifts"
        }
        
        struct Keys {
            struct User {
                static let NAME:String = "name"
                static let EMAIL:String = "email"
                static let PROFILE_IMG_URL:String = "profileImageURL"
                static let ID:String = "id"
            }
        }
    }
    
    struct KeyChain {
        static let Authorization:String = "Authorization"
        public static let USER_ID:String = "USER_ID"
        public static let BEARER:String = "Bearer"
        public static let PassCode:String = "PassCode"
    }
    
    struct UserDefaults {
        static let RegisterGiftDraft="RegisterGiftDraft"
        public static let PHONE_NUMBER:String = "PHONE_NUMBER"
        public static let WATCHED_INTRO:String = "watched_intro"
        
        public static let WATCHED_SELECT_LANGUAGE:String = "WATCHED_SELECT_LANGUAGE"
        public static let SELECTED_COUNTRY:String = "SELECTED_COUNTRY"
        
        public static let FirstInstall:String = "FirstInstall"
        static let AppleLanguages:String = "AppleLanguages"
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



