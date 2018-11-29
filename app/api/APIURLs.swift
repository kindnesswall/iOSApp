//
//  APIURLs.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class APIURLs {
//    static let BASE_URL="http://api.kindnesswall.ir/api/"
    static let UPLOAD_URL="http://api.kindnesswall.ir/api/"
    static let BASE_URL="http://test.kindnesswall.ir/api/"
    
    static let API_VERSION = "v01/"
    static let ACCOUNT = "Account/"

    // MARK: - Account
    static var register : String {
        return self.BASE_URL + self.ACCOUNT + "Register/"
    }
    static var logout : String {
        return self.BASE_URL + self.ACCOUNT + "Logout"
    }
    static var login : String {
        return self.BASE_URL + self.ACCOUNT + "Login"
    }
    static var setDevice : String {
        return self.BASE_URL + self.ACCOUNT + "SetDevice"
    }
    
    // MARK: - Others
    static var Gift : String {
        return self.BASE_URL + self.API_VERSION + "Gift/"
    }
    
    static var deleteMyRequest : String {
        return self.BASE_URL + self.API_VERSION + "DeleteMyRequest/"
    }
    
    static var acceptRequest : String {
        return self.BASE_URL + self.API_VERSION + "AcceptRequest/"
    }
    
    static var denyRequest : String {
        return self.BASE_URL + self.API_VERSION + "DenyRequest/"
    }
    
    static var bookmark : String {
        return self.BASE_URL + self.API_VERSION + "BookmarkGift"
    }
    
    static var Upload : String {
        return self.UPLOAD_URL + self.API_VERSION + "Upload"
    }
    
    static var getCategories : String {
        return self.BASE_URL + self.API_VERSION + "Category"
    }
    
    static var reportGift : String {
        return self.BASE_URL + self.API_VERSION + "ReportGift"
    }

    static var getSentRequestList : String {
        return self.BASE_URL + self.API_VERSION + "SentRequestList"
    }
    
    static var getBookmarkList : String {
        return self.BASE_URL + self.API_VERSION + "BookmarkList"
    }
    
    static var sendRequestGift : String {
        return self.BASE_URL + self.API_VERSION + "RequestGift"
    }
    
    static var getRequestsMyGifts : String {
        return self.BASE_URL + self.API_VERSION + "GiftsRequested"
    }
    
    static var getUser : String {
        return self.BASE_URL + self.API_VERSION + "User"
    }
    
    static var getStatistics : String {
        return self.BASE_URL + self.API_VERSION + "GetStatistics"
    }

    static var getRecievedRequestList : String {
        return self.BASE_URL + self.API_VERSION + "RecievedRequestList"
    }
    
    static var getMyRegisteredGifts : String {
        return self.BASE_URL + self.API_VERSION + "RegisteredGifts"
    }
    
    static var getMyDonatedGifts : String {
        return self.BASE_URL + self.API_VERSION + "DonatedGifts"
    }
    
    static var getMyReceivedGifts : String {
        return self.BASE_URL + self.API_VERSION + "ReceivedGifts"
    }
    
    static var getAppInfo : String {
        return self.BASE_URL + self.API_VERSION + "GetAppInfo"
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
