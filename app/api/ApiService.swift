//
//  ApiServiceProtocol.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol ApiServiceProtocol {

}

class ApiService:ApiServiceProtocol {
    let httpLayer: HTTPLayerProtocol
    init(_ httpLayer: HTTPLayerProtocol) {
        self.httpLayer = httpLayer
    }
    
    func cancelRequestAt(index:Int) {
        httpLayer.cancelRequestAt(index: index)
    }
    
    func cancelAllRequests() {
        httpLayer.cancelAllTasksAndSessions()
    }
    
    func findIndexOf(task:URLSessionTask?)->Int?{
        return httpLayer.findIndexOf(task: task)
    }
    
    func registerGift(
        _ gift:Gift, completion: @escaping (Result<Gift>) -> Void){
        registerEditGift(endPoint: Endpoint.RegisterGift(gift), completion)
    }
    
    func editGift(_ gift:Gift, completion: @escaping (Result<Gift>) -> Void){
        registerEditGift(endPoint: Endpoint.EditGift(gift), completion)
    }
    
    private func registerEditGift(endPoint:Endpoint,_ completion: @escaping (Result<Gift>) -> Void) {
        self.httpLayer.request(at: endPoint) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let resultGift = ApiUtility.convert(data: data, to: Gift.self){
                    completion(.success(resultGift))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func upload(imageInput:ImageInput, urlSessionDelegate: URLSessionDelegate,completion: @escaping (Result<String>) -> Void){
            self.httpLayer.upload(at: Endpoint.UploadImage(input: imageInput), urlSessionDelegate: urlSessionDelegate) { (result) in
           switch result{
           case .failure(let appError):
               completion(.failure(appError))
           case .success(let data):
               if let imageSrc=ApiUtility.convert(data: data, to: ImageOutput.self)?.address {
                   completion(.success(imageSrc))
               } else {
                   completion(.failure(AppError.DataDecoding))
               }
           }
       }
    }
    
    func giftRejectedAfterReview(giftId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.GiftReviewRejected(giftId: giftId)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func giftApprovedAfterReview(giftId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.GiftReviewApproved(giftId: giftId)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func sendPushNotification(to userId: Int, bodyMessage: String,completion: @escaping (Result<Void>) -> Void) {
        
        let input = SendPushInput(userId: userId, body: bodyMessage)
        
        self.httpLayer.request(at: Endpoint.SendPushNotif(input: input)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }

    func getUserStatistics(id userId: Int, completion: @escaping (Result<[String:Int]?>) -> Void){
        self.httpLayer.request(at: Endpoint.GetUserStatistics(userId: userId)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let statistics = ApiUtility.convert(data: data, to: [String:Int]?.self){
                    completion(.success(statistics))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func unblockUser(id userId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.UnBlockUserAccess(input: UnblockUserInput(userId: userId))) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func blockUser(id userId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.BlockUserAccess(userId: userId)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func acceptCharity(id charityId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.AcceptCharity(charityId: charityId)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func rejectCharity(id charityId: Int,completion: @escaping (Result<Void>) -> Void) {
        self.httpLayer.request(at: Endpoint.RejectCharity(charityId: charityId)) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func getStatistics(completion: @escaping (Result<[String:Int]?>) -> Void){
        
        self.httpLayer.request(at: Endpoint.Statistics) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                
                if let statistics = ApiUtility.convert(data: data, to: [String:Int]?.self){
                    completion(.success(statistics))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func getCharityList(completion: @escaping (Result<[Charity]>) -> Void){
        
        self.httpLayer.request(at: Endpoint.CharityList) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let charities = ApiUtility.convert(data: data, to: [Charity].self){
                    completion(.success(charities))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func getProvinces(completion: @escaping (Result<[Province]>) -> Void){
        
        self.httpLayer.request(at: Endpoint.GetProvinces) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let provinces = ApiUtility.convert(data: data, to: [Province].self){
                    completion(.success(provinces))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func getRegions(_ cityId: Int, completion: @escaping (Result<[Region]>) -> Void){
        self.httpLayer.request(at: Endpoint.GetRegions(cityId)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let provinces = ApiUtility.convert(data: data, to: [Region].self){
                    completion(.success(provinces))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func getCitieOfProvince(id: Int, completion: @escaping (Result<[City]>) -> Void){
        
        self.httpLayer.request(at: Endpoint.GetCitiesOfProvince(id: id)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let cities = ApiUtility.convert(data: data, to: [City].self){
                    completion(.success(cities))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func getCategories(completion: @escaping (Result<[Category]>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.GetCategories) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let categories = ApiUtility.convert(data: data, to: [Category].self){
                completion(.success(categories))
                }else{
                completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func requestPhoneNumberChange(to newPhoneNumber: String, completion: @escaping (Result<Void>)-> Void) {
        self.httpLayer.request(at: Endpoint.RequestPhoneNumberChange(toNewNumber: newPhoneNumber)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func validatePhoneNumberChange(to newPhoneNumber: String, with activationCode:String, completion: @escaping (Result<AuthOutput>)-> Void) {
        let input = ValidatePhoneNumberChangeIntput(phoneNumber: newPhoneNumber, activationCode: activationCode)
        self.httpLayer.request(at: Endpoint.ValidatePhoneNumberChange(input: input)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let authOutput = ApiUtility.convert(data:data , to: AuthOutput.self) {
                    completion(.success(authOutput))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func registerUser(phoneNumber: String, completion: @escaping (Result<Void>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.RegisterUser(User(phoneNumber: phoneNumber))) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func login(phoneNumber: String, activationCode: String, completion: @escaping (Result<AuthOutput>)-> Void) {
        
        let input = User(phoneNumber: phoneNumber,activationCode: activationCode)
        self.httpLayer.request(at: Endpoint.Login(user: input)) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let authOutput = ApiUtility.convert(data:data , to: AuthOutput.self) {
                    completion(.success(authOutput))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func requestGift(id: Int, completion: @escaping (Result<Chat>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.RequestGift(id: id)) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let chat = ApiUtility.convert(data:data , to: Chat.self) {
                    completion(.success(chat))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
        
    }
    
    func removeGift(id: Int, completion: @escaping (Result<Void>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.RemoveGift(id: id)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func donateGift(id:Int,toUserId:Int, completion: @escaping (Result<Gift>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.DonateGift(id: id, toUserId: toUserId)) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let gift = ApiUtility.convert(data:data , to: Gift.self) {
                    completion(.success(gift))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
            
        }
    }
    
    func getGifts(endPoint: Endpoint, completion: @escaping (Result<[Gift]>)-> Void) {
        self.httpLayer.request(at: endPoint) {[weak self] (result) in
            self?.handleGiftList(result: result, completion: completion)
        }
    }
    
    func handleGiftList(result: Result<Data>, completion: @escaping (Result<[Gift]>)-> Void) {
        switch result{
        case .failure(let appError):
            completion(.failure(appError))
        case .success(let data):
            if let gifts = ApiUtility.convert(data: data, to: [Gift].self){
                completion(.success(gifts))
            }else{
                completion(.failure(AppError.DataDecoding))
            }
        }
    }
    
    func updateUser(profile: UserProfile.Input, completion: @escaping (Result<Void>)-> Void) {
        self.httpLayer.request(at: Endpoint.UpdateUser(profile: profile)) {(result) in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func getUserProfile(userId: Int, completion: @escaping (Result<UserProfile>)-> Void) {
        self.httpLayer.request(at: Endpoint.GetProfile(userId: userId)) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let profile = ApiUtility.convert(data: data, to: UserProfile.self){
                    completion(.success(profile))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    
    func sendTextMessage(textMessage: TextMessage, completion: @escaping (Result<AckMessage>)-> Void) {
        self.httpLayer.request(at: Endpoint.SendTextMessage(textMessage: textMessage)) { result in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: AckMessage.self){
                    completion(.success(object))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func sendAck(ackMessage:AckMessage, completion: @escaping (Result<Void>)-> Void) {
        self.httpLayer.request(at: Endpoint.SendAck(ackMessage: ackMessage)) { result in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func getContacts(completion: @escaping (Result<[ContactMessage]>)-> Void){
        
        self.httpLayer.request(at: Endpoint.GetContacts) { result in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: [ContactMessage].self){
                    completion(.success(object))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
    }
    
    func fetchMessages(input: FetchMessagesInput, completion: @escaping (Result<ContactMessage>)-> Void){
        
        self.httpLayer.request(at: Endpoint.FetchMessages(input: input)) { result in
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let object = ApiUtility.convert(data: data, to: ContactMessage.self){
                    completion(.success(object))
                }else{
                    completion(.failure(AppError.DataDecoding))
                }
            }
        }
        
    }
    
    func registerPush(input:PushNotificationRegister, completion: @escaping (Result<Void>)-> Void) {
        self.httpLayer.request(at: Endpoint.RegisterPush(input: input)) { result in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
}

