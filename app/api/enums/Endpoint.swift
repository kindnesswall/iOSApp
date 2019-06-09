//
//  Endpoint.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol EndpointProtocol {
    var url:URL? {get}
    var httpMethod: String {get}
    var httpBody: Data? {get}
}

enum Endpoint:EndpointProtocol {

    case RegisterGift(_ gift:Gift)
    case EditGift(_ gift:Gift)

    var url:URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = self.scheme
        urlComponent.host = self.host
        urlComponent.port = 8080
        urlComponent.path = self.path
        urlComponent.queryItems = self.queryItems
        return urlComponent.url
    }
    
    var httpBody: Data? {
        switch self {
        case .RegisterGift(let gift):
            return ApiUtility.convert(input: gift)
        case .EditGift(let gift):
            return ApiUtility.convert(input: gift)
        }
    }
    
    var httpMethod: String {
        switch self {
        case .RegisterGift:
            return HttpMethod.POST.rawValue
        case .EditGift(_):
            return HttpMethod.PUT.rawValue
        }
    }
    
    var path:String {
        switch self {
        case .RegisterGift:
            return "/api/v1/gifts/register"
        case .EditGift(let gift):
            return "/api/v1/gifts/\(gift.id!)"
        }
    }
    
    var queryItems: [URLQueryItem] {
        let queryItems:[URLQueryItem] = []
        
        switch self {
        case .RegisterGift: break
        case .EditGift: break
        }
        
        return queryItems
    }
    
    var host:String{
        return "185.211.58.168"
    }
    
    var scheme:String {
        return "http"
    }
}
