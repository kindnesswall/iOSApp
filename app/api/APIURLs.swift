//
//  APIURLs.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class APIURLs {
    
    //Contact us links:
    static let githubLink = "https://github.com/kindnesswall"
    static let facebookLink = "https://www.facebook.com/profile.php?id=100018883545560"
    static let gmailLink = "mailto:info@kindnesswall.ir"
    static let instagramLink = "https://www.instagram.com/kindness_wall"
    static let telegramLink = "https://telegram.me/Kindness_Wall_Admin"
    static let webSiteLink = "http://www.kindnesswall.ir"
    
    
    
//    static let BASE_URL="http://api.kindnesswall.ir/api/"
    static let UPLOAD_URL="http://api.kindnesswall.ir/api/"
    static let BASE_URL="http://test.kindnesswall.ir/api/"
    
    static let API_VERSION = "v01/"
    static let ACCOUNT = "Account/"

    // MARK: - Others
    static var Gift : String {
        return self.BASE_URL + self.API_VERSION + "Gift/"
    }

    static var acceptRequest : String {
        return self.BASE_URL + self.API_VERSION + "AcceptRequest/"
    }

    static var denyRequest : String {
        return self.BASE_URL + self.API_VERSION + "DenyRequest/"
    }

    static var getRequestsMyGifts : String {
        return self.BASE_URL + self.API_VERSION + "GiftsRequested"
    }

    static var getStatistics : String {
        return self.BASE_URL + self.API_VERSION + "GetStatistics"
    }

    static var sendMessage : String {
        return self.BASE_URL + self.API_VERSION + "sendMessage"
    }

    static var getChatConversation : String {
        return self.BASE_URL + self.API_VERSION + "getChatConversation"
    }
    
    static var getChatList : String {
        return self.BASE_URL + self.API_VERSION + "getChatList"
    }

}
