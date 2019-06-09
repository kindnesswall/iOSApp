//
//  HTTPLayer.swift
//  app
//
//  Created by Hamed Ghadirian on 02.06.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

protocol HTTPLayerProtocol {
    func request(at endpoint: EndpointProtocol, completion: @escaping (Result<Data>) -> Void)
}

class HTTPLayer:HTTPLayerProtocol {
    
    var urlSession:URLSession
    init(urlSession:URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func setRequestHeader(request:URLRequest)->URLRequest {
        var newRequest=request
        newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorization=KeychainSwift().get(AppConst.KeyChain.Authorization) {
            newRequest.setValue(authorization, forHTTPHeaderField: AppConst.KeyChain.Authorization)
        }
        return newRequest
    }
    
    func createURLRequestFrom(endpoint: EndpointProtocol) throws -> URLRequest {
        
        guard let url = endpoint.url else {
            throw AppError.ApiUrlProblem
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpBody = endpoint.httpBody
        request.httpMethod = endpoint.httpMethod
        request = setRequestHeader(request: request)
        
        return request
    }
    
    func request(at endpoint: EndpointProtocol, completion: @escaping (Result<Data>) -> Void) {
        
        let request:URLRequest!
        
        do{
            request = try createURLRequestFrom(endpoint: endpoint)
        }catch{
            completion(.failure(AppError.ApiUrlProblem))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self](data, response, error) in
            
            self?.handleResponse(data, response, error, completion: completion)
        }
        task.resume()
    }
    
    func handleResponse(_ data:Data?,_ response:URLResponse?,_ error:Error?, completion: @escaping (Result<Data>) -> Void) {
        
        if let error = error as NSError? {
            switch error.code{
            case URLError.notConnectedToInternet.rawValue:
                completion(.failure(AppError.NoInternet))
            default:
                completion(.failure(AppError.Unknown))
            }
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
            completion(.failure(AppError.ServerError))
            return
        }
        
        if let data = data {
            completion(.success(data))
        }else{
            completion(.failure(AppError.Unknown))
        }
    }
    
}
