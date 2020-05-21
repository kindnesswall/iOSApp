//swiftlint:disable:file_length

//  ApiServiceProtocol.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol ApiServiceProtocol {

}

// swiftlint:disable:next type_body_length
class ApiService: ApiServiceProtocol {
    let httpLayer: HTTPLayerProtocol
    init(_ httpLayer: HTTPLayerProtocol) {
        self.httpLayer = httpLayer
    }

    func cancelRequestAt(index: Int) {
        httpLayer.cancelRequestAt(index: index)
    }

    func cancelAllRequests() {
        httpLayer.cancelAllTasksAndSessions()
    }

    func registerGift(
        _ gift: Gift, completion: @escaping (Result<Gift>) -> Void) {
        registerEditGift(endPoint: Endpoint.registerGift(gift), completion)
    }

    func editGift(_ gift: Gift, completion: @escaping (Result<Gift>) -> Void) {
        registerEditGift(endPoint: Endpoint.editGift(gift), completion)
    }

    private func registerEditGift(endPoint: Endpoint, _ completion: @escaping (Result<Gift>) -> Void) {
        self.httpLayer.request(at: endPoint) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let resultGift = ApiUtility.convert(data: data, to: Gift.self) {
                    completion(.success(resultGift))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }
    
    @discardableResult
    func upload(imageInput: ImageInput, urlSessionDelegate: URLSessionDelegate, completion: @escaping (Result<String>) -> Void) -> URLSessionUploadTask? {
        return self.httpLayer.upload(at: Endpoint.uploadImage(input: imageInput), urlSessionDelegate: urlSessionDelegate) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let imageSrc=ApiUtility.convert(data: data, to: ImageOutput.self)?.address {
                    completion(.success(imageSrc))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func giftRejectedAfterReview(giftId: Int, completion: @escaping (Result<Void>) -> Void) {
        let rejectInput = RejectGiftReviewInput(rejectReason: "")
        self.httpLayer.request(at: Endpoint.giftReviewRejected(giftId: giftId, input: rejectInput)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func giftApprovedAfterReview(giftId: Int, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.giftReviewApproved(giftId: giftId)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func sendPushNotification(to userId: Int, bodyMessage: String, completion: @escaping (Result<Void>) -> Void) {

        let input = SendPushInput(userId: userId, body: bodyMessage)

        self.httpLayer.request(at: Endpoint.sendPushNotif(input: input)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func getUserStatistics(id userId: Int, completion: @escaping (Result<[String: Int]?>) -> Void) {
        self.httpLayer.request(at: Endpoint.getUserStatistics(userId: userId)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let statistics = ApiUtility.convert(data: data, to: [String: Int]?.self) {
                    completion(.success(statistics))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func unblockUser(id userId: Int, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.unBlockUserAccess(input: UnblockUserInput(userId: userId))) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func blockUser(id userId: Int, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.blockUserAccess(userId: userId)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func acceptCharity(id charityId: Int, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.acceptCharity(charityId: charityId)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func rejectCharity(id charityId: Int, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.rejectCharity(charityId: charityId)) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func getStatistics(completion: @escaping (Result<[String: Int]?>) -> Void) {

        self.httpLayer.request(at: Endpoint.statistics) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):

                if let statistics = ApiUtility.convert(data: data, to: [String: Int]?.self) {
                    completion(.success(statistics))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func getCharityList(completion: @escaping (Result<[Charity]>) -> Void) {

        self.httpLayer.request(at: Endpoint.charityList) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let charities = ApiUtility.convert(data: data, to: [Charity].self) {
                    completion(.success(charities))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func checkYoutube(completion: @escaping (Result<[Country]>) -> Void) {
        self.httpLayer.request(at: Endpoint.getCountries) { result in
            var data: Data?
            switch result {
            case .failure(let appError):
                data =
                """
                [{
                "id":103,
                "name":"Iran",
                "phoneCode": "098",
                "localization": "fa"
                }]
                """.data(using: .utf8)
                print(appError)
            case .success:
                data =
                """
                [{
                "id":82,
                "name":"Germany",
                "phoneCode": "049",
                "localization": "de"
                }]
                """.data(using: .utf8)
            }
            if let countries = ApiUtility.convert(data: data, to: [Country].self) {
                DispatchQueue.main.async {
                    completion(.success(countries))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func getCountries(completion: @escaping (Result<[Country]>) -> Void) {
        self.httpLayer.request(at: Endpoint.getCountries) { result in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    completion(.failure(appError))
                }
            case .success(let data):
                if let countries = ApiUtility.convert(data: data, to: [Country].self) {
                    DispatchQueue.main.async {
                        completion(.success(countries))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(AppError.dataDecoding))
                    }
                }
            }
        }
    }

    func getProvinces(completion: @escaping (Result<[Province]>) -> Void) {

        guard let countryId = AppCountry.countryId else {
            completion(.failure(AppError.countryIsNotSpecified))
            return
        }
        self.httpLayer.request(at: Endpoint.getProvinces(countryId: countryId)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let provinces = ApiUtility.convert(data: data, to: [Province].self) {
                    completion(.success(provinces))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func getRegions(_ cityId: Int, completion: @escaping (Result<[Region]>) -> Void) {
        self.httpLayer.request(at: Endpoint.getRegions(cityId)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let provinces = ApiUtility.convert(data: data, to: [Region].self) {
                    completion(.success(provinces))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func getCitieOfProvince(id: Int, completion: @escaping (Result<[City]>) -> Void) {

        self.httpLayer.request(at: Endpoint.getCitiesOfProvince(id: id)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let cities = ApiUtility.convert(data: data, to: [City].self) {
                    completion(.success(cities))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func getCategories(completion: @escaping (Result<[Category]>) -> Void) {

        guard let countryId = AppCountry.countryId else {
            completion(.failure(AppError.countryIsNotSpecified))
            return
        }
        let input = CategoryInput(countryId: countryId)
        
        self.httpLayer.request(at: Endpoint.getCategories(input: input)) {(result) in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let categories = ApiUtility.convert(data: data, to: [Category].self) {
                completion(.success(categories))
                } else {
                completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func requestPhoneNumberChange(to newPhoneNumber: String, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.requestPhoneNumberChange(toNewNumber: newPhoneNumber)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func validatePhoneNumberChange(to newPhoneNumber: String, with activationCode: String, completion: @escaping (Result<AuthOutput>) -> Void) {
        let input = ValidatePhoneNumberChangeIntput(phoneNumber: newPhoneNumber, activationCode: activationCode)
        self.httpLayer.request(at: Endpoint.validatePhoneNumberChange(input: input)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let authOutput = ApiUtility.convert(data: data, to: AuthOutput.self) {
                    completion(.success(authOutput))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func registerUser(phoneNumber: String, completion: @escaping (Result<Void>) -> Void) {

        self.httpLayer.request(at: Endpoint.registerUser(User(phoneNumber: phoneNumber))) {(result) in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func login(phoneNumber: String, activationCode: String, completion: @escaping (Result<AuthOutput>) -> Void) {

        let input = User(phoneNumber: phoneNumber, activationCode: activationCode)
        self.httpLayer.request(at: Endpoint.login(user: input)) { result in
            ApiService.handleAuthOutputResult(result: result, completion: completion)
        }
    }

    func fireBaseLogin(input: FirebaseLoginInput, completion: @escaping (Result<AuthOutput>) -> Void) {

        let endPoint = Endpoint.firebaseLogin(input: input)
        self.httpLayer.request(at: endPoint) { result in
            ApiService.handleAuthOutputResult(result: result, completion: completion)
        }

    }

    private static func handleAuthOutputResult(result: Result<Data>, completion: @escaping (Result<AuthOutput>) -> Void) {

        switch result {
        case .failure(let appError):
            completion(.failure(appError))
        case .success(let data):
            if let authOutput = ApiUtility.convert(data: data, to: AuthOutput.self) {
                completion(.success(authOutput))
            } else {
                completion(.failure(AppError.dataDecoding))
            }
        }
    }

    func requestGift(id: Int, completion: @escaping (Result<ChatContacts>) -> Void) {

        self.httpLayer.request(at: Endpoint.requestGift(id: id)) {(result) in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let chat = ApiUtility.convert(data: data, to: ChatContacts.self) {
                    completion(.success(chat))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }

    }

    func requestGiftStatus(id: Int, completion: @escaping (Result<GiftRequestStatus>) -> Void) {
        self.httpLayer.request(at: Endpoint.requestGiftStatus(id: id)) { result in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let status = ApiUtility.convert(data: data, to: GiftRequestStatus.self) {
                    completion(.success(status))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func removeGift(id: Int, completion: @escaping (Result<Void>) -> Void) {

        self.httpLayer.request(at: Endpoint.removeGift(id: id)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func donateGift(id: Int, toUserId: Int, completion: @escaping (Result<Void>) -> Void) {

        self.httpLayer.request(at: Endpoint.donateGift(id: id, toUserId: toUserId)) {(result) in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }

        }
    }

    func getGifts(endPoint: Endpoint, completion: @escaping (Result<[Gift]>) -> Void) {
        self.httpLayer.request(at: endPoint) {[weak self] (result) in
            self?.handleGiftList(result: result, completion: completion)
        }
    }

    func handleGiftList(result: Result<Data>, completion: @escaping (Result<[Gift]>) -> Void) {
        switch result {
        case .failure(let appError):
            completion(.failure(appError))
        case .success(let data):
            if let gifts = ApiUtility.convert(data: data, to: [Gift].self) {
                completion(.success(gifts))
            } else {
                completion(.failure(AppError.dataDecoding))
            }
        }
    }

    func updateUser(profile: UserProfile.Input, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.updateUser(profile: profile)) {(result) in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func getUserProfile(userId: Int, completion: @escaping (Result<UserProfile>) -> Void) {
        self.httpLayer.request(at: Endpoint.getProfile(userId: userId)) {(result) in

            DispatchQueue.main.async {
                switch result {
                case .failure(let appError):
                    completion(.failure(appError))
                case .success(let data):
                    if let profile = ApiUtility.convert(data: data, to: UserProfile.self) {
                        completion(.success(profile))
                    } else {
                        completion(.failure(AppError.dataDecoding))
                    }
                }
            }
        }
    }

    func sendTextMessage(textMessage: TextMessage, completion: @escaping (Result<TextMessage>) -> Void) {
        self.httpLayer.request(at: Endpoint.sendTextMessage(textMessage: textMessage)) { result in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: TextMessage.self) {
                    completion(.success(object))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func sendAck(ackMessage: AckMessage, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.sendAck(ackMessage: ackMessage)) { result in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func getContacts(blockedChats: Bool, completion: @escaping (Result<[ContactMessage]>) -> Void) {

        let endPoint = blockedChats ? Endpoint.getBlockContacts : Endpoint.getContacts

        self.httpLayer.request(at: endPoint) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: [ContactMessage].self) {
                    completion(.success(object))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }
    }

    func blockOrUnblockChat(blockCase: BlockCase, chatId: Int, completion: @escaping (Result<Void>) -> Void) {

        let endPoint = blockCase == .block ? Endpoint.blockChat(id: chatId) : Endpoint.unBlockChat(id: chatId)
        self.httpLayer.request(at: endPoint) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let appError):
                    completion(.failure(appError))
                case .success:
                    completion(.success(Void()))
                }
            }
        }
    }

    func fetchMessages(input: FetchMessagesInput, completion: @escaping (Result<ContactMessage>) -> Void) {

        self.httpLayer.request(at: Endpoint.fetchMessages(input: input)) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: ContactMessage.self) {
                    completion(.success(object))
                } else {
                    completion(.failure(AppError.dataDecoding))
                }
            }
        }

    }

    func registerPush(input: PushNotificationRegister, completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.registerPush(input: input)) { result in

            switch result {
            case .failure(let appError):
                completion(.failure(appError))
            case .success:
                completion(.success(Void()))
            }
        }
    }
}
