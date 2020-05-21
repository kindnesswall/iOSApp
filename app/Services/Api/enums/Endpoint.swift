//
//  Endpoint.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol EndpointProtocol {
    var url: URL? {get}
    var httpMethod: String {get}
    var httpBody: Data? {get}
}

// swiftlint:disable:next type_body_length
enum Endpoint: EndpointProtocol {

    case getYoutube
//        ---------------------------------------
    case getCountries
    case getProvinces(countryId: Int)
    case getCitiesOfProvince(id: Int)
    case getCategories(input: CategoryInput)
    case getRegions(_ cityId: Int)
//        ---------------------------------------
    case registerUser(_ user: User)
    case login(user: User)
    case firebaseLogin(input: FirebaseLoginInput)
    case requestPhoneNumberChange(toNewNumber: String)
    case validatePhoneNumberChange(input: ValidatePhoneNumberChangeIntput)
//        ---------------------------------------
    case registerGift(_ gift: Gift)
    case editGift(_ gift: Gift)
    case removeGift(id: Int)
    case requestGift(id: Int)
    case requestGiftStatus(id: Int)
    case donateGift(id: Int, toUserId: Int)

    case giftsToReview(input: GiftsRequestInput)
    case userDonatedGifts(userId: Int, input: GiftsRequestInput)
    case userReceivedGifts(userId: Int, input: GiftsRequestInput)
    case userRegisteredGifts(userId: Int, input: GiftsRequestInput)
    case getGifts(input: GiftsRequestInput)
    case giftsToDonate(toUserId: Int, input: GiftsRequestInput)
//        ---------------------------------------
    case sendTextMessage(textMessage: TextMessage)
    case sendAck(ackMessage: AckMessage)
    case fetchMessages(input: FetchMessagesInput)
//        ---------------------------------------
    case registerPush(input: PushNotificationRegister)
    case sendPushNotif(input: SendPushInput)
//        ---------------------------------------
    case getProfile(userId: Int)
    case updateUser(profile: UserProfile.Input)
//        ---------------------------------------
    case giftReviewRejected(giftId: Int, input: RejectGiftReviewInput)
    case giftReviewApproved(giftId: Int)
//        ---------------------------------------
    case charityList
    case acceptCharity(charityId: Int)
    case rejectCharity(charityId: Int)
//        ---------------------------------------
    case statistics
//        ---------------------------------------
    case blockUserAccess(userId: Int)
    case getUserStatistics(userId: Int)
    case unBlockUserAccess(input: UnblockUserInput)
//        ---------------------------------------
    case getContacts
    case getBlockContacts
//        ---------------------------------------
    case chatSendMessage(input: SendMessageInput)
    case chatAckMessage(input: ChatAckMessageInput)
    case blockChat(id: Int)
    case unBlockChat(id: Int)
    //        ---------------------------------------
    case uploadImage(input: ImageInput)

    private var basePathUrl: String { return "/api/v1/"}
    private var usersBaseURL: String { return basePathUrl + "users/" }
    private var chatBaseURL: String { return basePathUrl + "chat/" }
    private var contactsBaseURL: String { return chatBaseURL + "contacts/" }
    private var giftsBaseURL: String { return basePathUrl + "gifts/" }
    private var charityBaseURL: String { return basePathUrl + "charity/" }
    private var profileBaseURL: String { return basePathUrl + "profile/" }
    private var registerBaseURL: String { return basePathUrl + "register/" }
    private var phoneNumberChangeBaseURL: String { return registerBaseURL + "phoneNumberChange/" }

    var url: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = self.scheme
        urlComponent.host = self.host
        urlComponent.port = 80
        urlComponent.path = self.path
        urlComponent.queryItems = self.queryItems
        return urlComponent.url
    }

    var httpBody: Data? {
        switch self {

        case .getYoutube, .getCountries, .getProfile,
             .getBlockContacts, .getContacts, .getUserStatistics,
             .unBlockChat, .blockChat, .blockUserAccess, .statistics,
             .rejectCharity, .charityList, .acceptCharity, .giftReviewApproved,
             .getProvinces, .getCitiesOfProvince, .getRegions, .removeGift, .requestGift, .requestGiftStatus:
            return nil

        case .getCategories(let input):
            return ApiUtility.convert(input: input)
            
        case .giftReviewRejected(_, let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .registerUser(let user), .login(let user):
            return ApiUtility.convert(input: user)
//        ---------------------------------------
        case .registerGift(let gift), .editGift(let gift):
            return ApiUtility.convert(input: gift)

        case .donateGift(let id, let toUserId):
            return ApiUtility.convert(input: Donate(giftId: id, donatedToUserId: toUserId))

        case .giftsToReview(let input), .userDonatedGifts(_, let input), .userReceivedGifts(_, let input), .userRegisteredGifts(_, let input), .giftsToDonate(_, let input), .getGifts(let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .sendTextMessage(let textMessage):
            return ApiUtility.convert(input: textMessage)
        case .sendAck(let ackMessage):
            return ApiUtility.convert(input: ackMessage)
        case .fetchMessages(let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .registerPush(let input):
            return ApiUtility.convert(input: input)
        case .sendPushNotif(let input):
            return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .updateUser(let profile):
            return ApiUtility.convert(input: profile)
//        ---------------------------------------
        case .unBlockUserAccess(let input): return ApiUtility.convert(input: input)
//        ---------------------------------------
        case .chatSendMessage(let input): return ApiUtility.convert(input: input)
        case .chatAckMessage(let input): return ApiUtility.convert(input: input)

        case .requestPhoneNumberChange(let toNewNumber):
            return ApiUtility.convert(input: toNewNumber)
        case .validatePhoneNumberChange(let input):
            return ApiUtility.convert(input: input)

        case .uploadImage(let input):
            return ApiUtility.convert(input: input)

        case .firebaseLogin(let input):
            return ApiUtility.convert(input: input)
        }
    }

    var httpMethod: String {
        switch self {
        case .getYoutube, .getCountries, .getProvinces,
             .getCitiesOfProvince, .getRegions, .requestGift,
             .requestGiftStatus, .getProfile, .charityList,
             .statistics, .getUserStatistics, .getContacts, .getBlockContacts:
            return HttpMethod.get.rawValue

        case .getCategories, .registerUser, .login,
             .firebaseLogin, .registerGift, .donateGift,
             .giftsToDonate, .userRegisteredGifts, .userReceivedGifts,
             .userDonatedGifts, .sendTextMessage, .sendAck,
             .fetchMessages, .registerPush, .giftsToReview,
             .sendPushNotif, .updateUser, .chatSendMessage,
             .chatAckMessage, .getGifts, .requestPhoneNumberChange,
             .validatePhoneNumberChange, .uploadImage:
            return HttpMethod.post.rawValue

        case .editGift, .giftReviewApproved, .acceptCharity, .rejectCharity, .unBlockUserAccess, .unBlockChat, .blockChat, .giftReviewRejected:
            return HttpMethod.put.rawValue

        case .removeGift, .blockUserAccess:
            return HttpMethod.delete.rawValue
        }
    }

    private var path: String {
        switch self {
        case .getYoutube:
            return "https://www.youtube.com/"
        case .uploadImage:
            return basePathUrl+"/image/upload"
//        ---------------------------------------
        case .getCountries:
            return basePathUrl+"countries"
        case .getProvinces(let countryId):
            return basePathUrl+"provinces/\(countryId)"
        case .getCitiesOfProvince(let id):
            return basePathUrl+"cities/\(id)"
        case .getCategories:
            return basePathUrl+"categories"
        case .getRegions(let cityId):
            return basePathUrl+"regions/\(cityId)"
//        ---------------------------------------
        case .registerUser:
            return registerBaseURL
        case .login:
            return basePathUrl+"login"
        case .firebaseLogin:
            return basePathUrl+"login/firebase"
//        ---------------------------------------
        case .registerGift:
            return giftsBaseURL+"register"
        case .editGift(let gift):
            return giftsBaseURL+"\(gift.id!)"
        case .removeGift(let id):
            return giftsBaseURL+"\(id)"
        case .requestGift(let id):
            return giftsBaseURL+"request/\(id)"
        case .requestGiftStatus(let id):
            return giftsBaseURL+"request/status/\(id)"
        case .donateGift:
            return basePathUrl+"donate"

        case .giftsToReview:
            return giftsBaseURL + "review"
        case .userDonatedGifts(let userId, _):
            return giftsBaseURL + "userDonated/\(userId)"
        case .userReceivedGifts(let userId, _):
            return giftsBaseURL + "userReceived/\(userId)"
        case .userRegisteredGifts(let userId, _):
            return giftsBaseURL + "userRegistered/\(userId)"
        case .getGifts:
            return giftsBaseURL
        case .giftsToDonate(let toUserId, _):
            return giftsBaseURL + "todonate/\(toUserId)"
//        ---------------------------------------
        case .sendTextMessage:
            return chatBaseURL + "send"
        case .sendAck:
            return chatBaseURL + "ack"
        case .fetchMessages:
            return chatBaseURL + "messages"
//        ---------------------------------------
        case .registerPush:
            return basePathUrl + "push/register"
        case .sendPushNotif:
            return basePathUrl + "sendPush"
//        ---------------------------------------
        case .getProfile(let userId):
            return profileBaseURL + "\(userId)"
        case .updateUser:
            return profileBaseURL
//        ---------------------------------------
        case .giftReviewRejected(let giftId, _):
            return giftsBaseURL + "reject/\(giftId)"
        case .giftReviewApproved(let giftId):
            return giftsBaseURL + "accept/\(giftId)"
//        ---------------------------------------
        case .charityList:
            return charityBaseURL + "list"
        case .acceptCharity(let charityId):
            return charityBaseURL + "accept/\(charityId)"
        case .rejectCharity(let charityId):
            return charityBaseURL + "reject/\(charityId)"
//        ---------------------------------------
        case .statistics:
            return basePathUrl + "statistics"
//        ---------------------------------------
        case .blockUserAccess(let userId):
            return usersBaseURL + "denyAccess/\(userId)"
        case .unBlockUserAccess:
            return usersBaseURL + "allowAccess"
        case .getUserStatistics(let userId):
            return usersBaseURL + "statistics/\(userId)"
//        ---------------------------------------
        case .getContacts: return contactsBaseURL
        case .getBlockContacts: return contactsBaseURL + "block"
//        ---------------------------------------
        case .chatSendMessage: return chatBaseURL + "send"
        case .chatAckMessage: return chatBaseURL + "ack"
        case .blockChat(let chatId): return chatBaseURL + "block/\(chatId)"
        case .unBlockChat(let chatId): return chatBaseURL + "unblock/\(chatId)"

        case .requestPhoneNumberChange:
            return phoneNumberChangeBaseURL + "request"
        case .validatePhoneNumberChange:
            return phoneNumberChangeBaseURL + "validate"
        }
    }

    private var queryItems: [URLQueryItem] {
        let queryItems: [URLQueryItem] = []
        return queryItems
    }

    private var host: String {
        return "dev.kindnesswand.com"
//        return "localhost"
    }

    private var scheme: String {
        return "http"
    }
}
