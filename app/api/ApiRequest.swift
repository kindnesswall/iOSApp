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
    init(httpLayer: HTTPLayerProtocol) {
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
    
//    static func approveGift(id giftId:String) {
//        let url = "\(URIs().gifts_accept)/\(giftId)"
//        let input = EmptyInput()
//        APICall.request(url: url, httpMethod: HttpMethod.POST, input: input) { (data, response, error) in
//            //            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == APICall.OKStatus else {
//            //                print("Get error register")
//            //                self?.handleError(beforeId: beforeId)
//            //                return
//            //            }
//            //
//            //            if let reply=ApiUtility.convert(data: data, to: [Gift].self) {
//            //                self?.handleResponse(beforeId:beforeId, recieveGifts:reply)
//            //            }
//        }
//        
//    }
    
}

