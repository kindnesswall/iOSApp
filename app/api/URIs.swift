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
        self.apiRoute="http://185.211.58.168:8080/api/v1"
    }
    
    var gifts : String {
        return "\(apiRoute)/gifts"
    }
    var categories : String {
        return "\(apiRoute)/categories"
    }
    var province : String {
        return "\(apiRoute)/provinces"
    }
    var city : String {
        return "\(apiRoute)/cities"
    }
    var register : String {
        return "\(apiRoute)/register"
    }
    var login : String {
        return "\(apiRoute)/login"
    }
    var chat : String {
        return "\(apiRoute)/chat"
    }
    
    var gifts_register : String {
        return "\(apiRoute)/gifts/register"
    }
    
    var gifts_owner : String {
        return "\(apiRoute)/gifts/owner"
    }
    var gifts_donated: String {
        return "\(apiRoute)/gifts/donated"
    }
    var gifts_received : String {
        return "\(apiRoute)/gifts/received"
    }
    var gifts_todonate : String {
        return "\(apiRoute)/gifts/todonate"
    }
    
    var gifts_images : String {
        return "\(apiRoute)/gifts/images"
    }
    
    var gifts_accept : String {
        return "\(apiRoute)/gifts/accept"
    }
    var gifts_reject : String {
        return "\(apiRoute)/gifts/reject"
    }
    var gifts_review : String {
        return "\(apiRoute)/gifts/review"
    }
    var users_allowAccess : String {
        return "\(apiRoute)/users/allowAccess"
    }
    var users_denyAccess : String {
        return "\(apiRoute)/users/denyAccess"
    }
    
    var gifts_request : String {
        return "\(apiRoute)/gifts/request"
    }
    var donate : String {
        return "\(apiRoute)/donate"
    }
    
    func getSMSUrl(apiKey:String,receptor:String,template:String,token:String)->String?{
        let rawUrl = "https://saharsms.com/api/\(apiKey)/json/SendVerify?receptor=\(receptor)&template=\(template)&token=\(token)"
        let encodedURL = rawUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodedURL
    }
}
