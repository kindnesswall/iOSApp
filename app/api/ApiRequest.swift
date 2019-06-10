//
//  ApiRequestProtocol.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol ApiRequestProtocol {

}

class ApiRequest:ApiRequestProtocol {
    let httpLayer: HTTPLayerProtocol
    init(_ httpLayer: HTTPLayerProtocol) {
        self.httpLayer = httpLayer
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
    
    func login(phoneNumber: String, activationCode: String, completion: @escaping (Result<Token>)-> Void) {
        
        let input = User(phoneNumber: phoneNumber,activationCode: activationCode)
        self.httpLayer.request(at: Endpoint.Login(user: input)) {(result) in
            
            switch result{
            case .failure(let appError):
                completion(.failure(appError))
            case .success(let data):
                if let token = ApiUtility.convert(data:data , to: Token.self) {
                    completion(.success(token))
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
    
    func getGifts(params: GiftListRequestParameters, completion: @escaping (Result<[Gift]>)-> Void) {
        
        self.httpLayer.request(at: Endpoint.GetGifts(param: params)) {(result) in
            
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
    }
}

