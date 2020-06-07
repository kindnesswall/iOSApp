//
//  AppConst.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

struct AppConst {

    struct KeyChain {
        static let Authorization: String = "Authorization"
        public static let UserID: String = "USER_ID"
        public static let BEARER: String = "Bearer"
        public static let PassCode: String = "PassCode"
        public static let IsAdmin: String = "IsAdmin"
        public static let IsCharity: String = "IsCharity"
        public static let PushToken = "PushToken"
        public static let DeviceIdentifier = "DeviceIdentifier"
    }

    struct UserDefaults {
        static let RegisterGiftDraft="RegisterGiftDraft"
        public static let PhoneNumber: String = "PHONE_NUMBER"
        public static let WatchedIntro: String = "watched_intro"

        public static let WatchedSelectLanguage: String = "WATCHED_SELECT_LANGUAGE"
        public static let SelectedCountry: String = "SELECTED_COUNTRY"

        public static let HasInstalledBefore: String = "HasInstalledBefore"
        static let AppleLanguages: String = "AppleLanguages"
    }

    struct TabIndex {
        public static let HOME: Int = 0
        public static let Charities: Int = 1
        public static let MyWall: Int = 1
        public static let RegisterGift: Int = 2
        public static let Chat: Int = 3
        public static let More: Int = 4
    }

    struct URL {
        //Contact us links:
        static let githubLink = "https://github.com/kindnesswall"
        static let facebookLink = "https://www.facebook.com/profile.php?id=100018883545560"
        static let gmailLink = "mailto:info@kindnesswall.ir"
        static let instagramLink = "https://www.instagram.com/kindness_wall"
        static let telegramLink = "https://telegram.me/Kindness_Wall_Admin"
        static let webSiteLink = "http://www.kindnesswall.ir"
    }
    
    struct DemoAccount {
        static let phoneNumber = "+499000000000"
    }
}
