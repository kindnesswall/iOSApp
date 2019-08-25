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
    
    var chat : String {
        return "\(apiRoute)/chat"
    }
    
    var image_upload : String {
        return "\(apiRoute)/image/upload"
    }
    
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
