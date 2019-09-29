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

//        ---------------------------------------
    case GetProvinces
    case GetCitiesOfProvince(id:Int)
    case GetCategories
    case GetRegions(_ cityId:Int)
//        ---------------------------------------
    case RegisterUser(_ user:User)
    case Login(user:User)
//        ---------------------------------------
    case RegisterGift(_ gift:Gift)
    case EditGift(_ gift:Gift)
    case RemoveGift(id:Int)
    case RequestGift(id:Int)
    case DonateGift(id:Int,toUserId:Int)
    case GetGifts(param: GiftListRequestParameters)
//        ---------------------------------------
    case SendTextMessage(textMessage: TextMessage)
    case SendAck(ackMessage: AckMessage)
    case FetchMessages(input: FetchMessagesInput)
//        ---------------------------------------
    case RegisterPush(input: PushNotificationRegister)
    case SendPushNotif(input: SendPushInput)
//        ---------------------------------------
    case GetProfile(userId: Int)
    case UpdateUser(profile: UserProfile.Input)
//        ---------------------------------------
    case GiftReviewRejected(giftId: Int)
    case GiftReviewApproved(giftId: Int)
//        ---------------------------------------
    case CharityList
    case AcceptCharity(charityId: Int)
    case RejectCharity(charityId: Int)
//        ---------------------------------------
    case Statistics
//        ---------------------------------------
    case BlockUserAccess(userId:Int)
    case GetUserStatistics(userId:Int)
    case UnBlockUserAccess(input: UnblockUserInput)
//        ---------------------------------------
    case GetContacts
    case GetBlockContacts
//        ---------------------------------------
    case ChatSendMessage(input: SendMessageInput)
    case ChatAckMessage(input: ChatAckMessageInput)
    case BlockChat(id: Int)
    case UnBlockChat(id: Int)
    
    var basePathUrl:String{ return "/api/v1/"}
    var usersBaseURL:String { return basePathUrl + "users/" }
    var chatBaseURL:String { return basePathUrl + "chat/" }
    var contactsBaseURL:String { return chatBaseURL + "contacts/" }
    var giftsBaseURL:String{ return basePathUrl + "gifts/" }
    var charityBaseURL:String{ return basePathUrl + "charity/" }
    var profileBaseURL:String{ return basePathUrl + "profile/" }
    
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
            
        case .GetProfile, .GetBlockContacts, .GetContacts, .GetUserStatistics, .UnBlockChat, .BlockChat, .BlockUserAccess, .Statistics, .RejectCharity, .CharityList, .AcceptCharity, .GiftReviewApproved, .GiftReviewRejected, .GetProvinces, .GetCategories, .GetCitiesOfProvince(_), .GetRegions(_), .RemoveGift, .RequestGift:
            return nil

//        ---------------------------------------
        case .RegisterUser(let user), .Login(let user):
            return ApiUtility.convert(input: user)
//        ---------------------------------------
        case .RegisterGift(let gift), .EditGift(let gift):
            return ApiUtility.convert(input: gift)
        
        case .DonateGift(let id, let toUserId):
            return ApiUtility.convert(input: Donate(giftId: id, donatedToUserId: toUserId))
        case .GetGifts(let param):
            return ApiUtility.convert(input: param.input)
//        ---------------------------------------
        case .SendTextMessage(let textMessage):
            return ApiUtility.convert(input: textMessage)
        case .SendAck(let ackMessage):
            return ApiUtility.convert(input: ackMessage)
        case .FetchMessages(let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .RegisterPush(let input):
            return ApiUtility.convert(input: input)
        case .SendPushNotif(let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .UpdateUser(let profile):
            return ApiUtility.convert(input: profile)
//        ---------------------------------------
        case .UnBlockUserAccess(let input): return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .ChatSendMessage(let input): return ApiUtility.convert(input: input)
        case .ChatAckMessage(let input): return ApiUtility.convert(input: input)      
        }
    }
    
    var httpMethod: String {
        switch self {
        case .GetProvinces, .GetCitiesOfProvince(_), .GetCategories, .GetRegions(_), .RequestGift(_), .GetProfile(_), .CharityList, .Statistics, .GetUserStatistics, .GetContacts, .GetBlockContacts:
            return HttpMethod.GET.rawValue

        case .RegisterUser(_), .Login(_), .RegisterGift, .DonateGift(_,_), .GetGifts(_), .SendTextMessage(_), .SendAck(_), .FetchMessages(_), .RegisterPush(_), .SendPushNotif, .UpdateUser, .ChatSendMessage, .ChatAckMessage:
            return HttpMethod.POST.rawValue
            
        case .EditGift(_), .GiftReviewApproved, .AcceptCharity, .RejectCharity, .UnBlockUserAccess, .UnBlockChat, .BlockChat:
            return HttpMethod.PUT.rawValue
            
        case .RemoveGift(_), .GiftReviewRejected, .BlockUserAccess:
            return HttpMethod.DELETE.rawValue
        }
    }
    
    
    var path:String {
        switch self {
//        ---------------------------------------
        case .GetProvinces:
            return basePathUrl+"provinces"
        case .GetCitiesOfProvince(let id):
            return basePathUrl+"cities/\(id)"
        case .GetCategories:
            return basePathUrl+"categories"
        case .GetRegions(let cityId):
            return basePathUrl+"regions/\(cityId)"
//        ---------------------------------------
        case .RegisterUser(_):
            return basePathUrl+"register"
        case .Login(_):
            return basePathUrl+"login"
//        ---------------------------------------
        case .RegisterGift:
            return giftsBaseURL+"register"
        case .EditGift(let gift):
            return giftsBaseURL+"\(gift.id!)"
        case .RemoveGift(let id):
            return giftsBaseURL+"\(id)"
        case .RequestGift(let id):
            return giftsBaseURL+"request/\(id)"
        case .DonateGift(_,_):
            return basePathUrl+"donate"
        case .GetGifts(let param):
            return basePathUrl+param.type.path
//        ---------------------------------------
        case .SendTextMessage:
            return chatBaseURL + "send"
        case .SendAck:
            return chatBaseURL + "ack"
        case .FetchMessages(_):
            return chatBaseURL + "messages"
//        ---------------------------------------
        case .RegisterPush(_):
            return basePathUrl + "push/register"
        case .SendPushNotif(_):
            return basePathUrl + "sendPush"
//        ---------------------------------------
        case .GetProfile(let userId):
            return profileBaseURL + "\(userId)"
        case .UpdateUser(_):
            return profileBaseURL
//        ---------------------------------------
        case .GiftReviewRejected(let giftId):
            return giftsBaseURL + "reject/\(giftId)"
        case .GiftReviewApproved(let giftId):
            return giftsBaseURL + "accept/\(giftId)"
//        ---------------------------------------
        case .CharityList:
            return charityBaseURL + "list"
        case .AcceptCharity(let charityId):
            return charityBaseURL + "accept/\(charityId)"
        case .RejectCharity(let charityId):
            return charityBaseURL + "reject/\(charityId)"
//        ---------------------------------------
        case .Statistics:
            return basePathUrl + "statistics"
//        ---------------------------------------
        case .BlockUserAccess(let userId):
            return usersBaseURL + "denyAccess/\(userId)"
        case .UnBlockUserAccess(_):
            return usersBaseURL + "allowAccess"
        case .GetUserStatistics(let userId):
            return usersBaseURL + "statistics/\(userId)"
//        ---------------------------------------
        case .GetContacts: return contactsBaseURL
        case .GetBlockContacts: return contactsBaseURL + "block"
//        ---------------------------------------
        case .ChatSendMessage: return chatBaseURL + "send"
        case .ChatAckMessage: return chatBaseURL + "ack"
        case .BlockChat(let chatId): return chatBaseURL + "block/\(chatId)"
        case .UnBlockChat(let chatId): return chatBaseURL + "unblock/\(chatId)"
            
        }
    }
    
    var queryItems: [URLQueryItem] {
        let queryItems:[URLQueryItem] = []
        return queryItems
    }
    
    var host:String{
        return "185.211.58.168"
//        return "localhost"
    }
    
    var scheme:String {
        return "http"
    }
}
