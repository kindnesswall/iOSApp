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

    case GetProvinces
    case GetCitiesOfProvince(id:Int)
    case GetCategories
    
    case RegisterUser(_ user:User)
    case Login(user:User)
    
    case RegisterGift(_ gift:Gift)
    case EditGift(_ gift:Gift)
    
    case RemoveGift(id:Int)
    case RequestGift(id:Int)
    case DonateGift(id:Int,toUserId:Int)
    case GetGifts(param: GiftListRequestParameters)
    
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
        case .GetProvinces: return nil
        case .GetCategories: return nil
        case .GetCitiesOfProvince(_): return nil
        case .RegisterUser(let user):
            return ApiUtility.convert(input: user)
        case .Login(let user):
            return ApiUtility.convert(input: user)
        case .RemoveGift: return nil
        case .RequestGift: return nil
        case .DonateGift(let id, let toUserId):
            return ApiUtility.convert(input: Donate(giftId: id, donatedToUserId: toUserId))
        case .GetGifts(let param):
            return ApiUtility.convert(input: param.input)
        }
    }
    
    var httpMethod: String {
        switch self {
        case .RegisterGift:
            return HttpMethod.POST.rawValue
        case .EditGift(_):
            return HttpMethod.PUT.rawValue
        case .GetProvinces:
            return HttpMethod.GET.rawValue
        case .GetCitiesOfProvince(_):
            return HttpMethod.GET.rawValue
        case .GetCategories:
            return HttpMethod.GET.rawValue
        case .RegisterUser(_):
            return HttpMethod.POST.rawValue
        case .Login(_):
            return HttpMethod.POST.rawValue
        case .RemoveGift(_):
            return HttpMethod.DELETE.rawValue
        case .RequestGift(_):
            return HttpMethod.GET.rawValue
        case .DonateGift(_,_):
            return HttpMethod.POST.rawValue
        case .GetGifts(_):
            return HttpMethod.POST.rawValue
        }
    }
    
    var basePathUrl:String{ return "/api/v1/"}
    
    var path:String {
        switch self {
        case .RegisterGift:
            return basePathUrl+"gifts/register"
        case .EditGift(let gift):
            return basePathUrl+"gifts/\(gift.id!)"
        case .GetProvinces:
            return basePathUrl+"provinces"
        case .GetCitiesOfProvince(let id):
            return basePathUrl+"cities/\(id)"
        case .GetCategories:
            return basePathUrl+"categories"
        case .RegisterUser(_):
            return basePathUrl+"register"
        case .Login(_):
            return basePathUrl+"login"
        case .RemoveGift(let id):
            return basePathUrl+"gifts/\(id)"
        case .RequestGift(let id):
            return basePathUrl+"gifts/request/\(id)"
        case .DonateGift(_,_):
            return basePathUrl+"donate"
        case .GetGifts(let param):
            return basePathUrl+param.type.path
        }
    }
    
    var queryItems: [URLQueryItem] {
        let queryItems:[URLQueryItem] = []
        
        switch self {
        case .RegisterGift: break
        case .EditGift: break
        case .GetProvinces: break
        case .GetCitiesOfProvince: break
        case .GetCategories: break
        case .RegisterUser: break
        case .Login: break
        case .RemoveGift: break
        case .RequestGift: break
        case .DonateGift: break
        case .GetGifts: break
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