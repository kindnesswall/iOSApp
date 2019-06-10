//
//  URIs.swift
//  COpenSSL
//
//  Created by Amir Hossein on 1/6/19.
//

import Foundation

class URIs {
    private let apiRoute:String
    init() {
//        self.apiRoute="http://localhost:8080/api/v1"
        self.apiRoute="http://185.211.58.168:8080/api/v1"
    }
    
//    var gifts : String {
//        return "\(apiRoute)/gifts"
//    }
//
    var chat : String {
        return "\(apiRoute)/chat"
    }
    
//    var gifts_register : String {
//        return "/api/v1/gifts/register"
//    }
    
//    var gifts_owner : String {
//        return "\(apiRoute)/gifts/owner"
//    }
    
//    var gifts_donated: String {
//        return "\(apiRoute)/gifts/donated"
//    }
//
//    var gifts_received : String {
//        return "\(apiRoute)/gifts/received"
//    }
//
//    var gifts_todonate : String {
//        return "\(apiRoute)/gifts/todonate"
//    }
//
    var image_upload : String {
        return "\(apiRoute)/image/upload"
    }
    
//    var gifts_accept : String {
//        return "\(apiRoute)/gifts/accept"
//    }
//    var gifts_reject : String {
//        return "\(apiRoute)/gifts/reject"
//    }
//    var gifts_review : String {
//        return "\(apiRoute)/gifts/review"
//    }
//    var users_allowAccess : String {
//        return "\(apiRoute)/users/allowAccess"
//    }
//    var users_denyAccess : String {
//        return "\(apiRoute)/users/denyAccess"
//    }
    
//    var gifts_request : String {
//        return "\(apiRoute)/gifts/request"
//    }
//    var donate : String {
//        return "\(apiRoute)/donate"
//    }
//    var profile : String {
//        return "\(apiRoute)/profile"
//    }
    
    
    func getSMSUrl(apiKey:String,receptor:String,template:String,token:String)->String?{
        let rawUrl = "https://saharsms.com/api/\(apiKey)/json/SendVerify?receptor=\(receptor)&template=\(template)&token=\(token)"
        let encodedURL = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedURL
    }
    
    //Contact us links:
    static let githubLink = "https://github.com/kindnesswall"
    static let facebookLink = "https://www.facebook.com/profile.php?id=100018883545560"
    static let gmailLink = "mailto:info@kindnesswall.ir"
    static let instagramLink = "https://www.instagram.com/kindness_wall"
    static let telegramLink = "https://telegram.me/Kindness_Wall_Admin"
    static let webSiteLink = "http://www.kindnesswall.ir"
}
