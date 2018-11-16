//
//  APICall.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

enum HttpCallMethod :String{
    case POST="POST"
    case GET="GET"
    case PUT="PUT"
    case DELETE="DELETE"
}

class APICall {
    
    //MARK: - Requests
    
    private static func setRequestHeader(request:URLRequest)->URLRequest {
        var newRequest=request
        newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorization=KeychainSwift().get(AppConstants.Authorization) {
            newRequest.setValue(authorization, forHTTPHeaderField: AppConstants.Authorization)
//            print("Authorization: \(authorization)")
        }
        return newRequest
    }
    
    static func request<InputCodable:Codable>(url urlString:String,httpMethod:HttpCallMethod,input:InputCodable?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        guard let url=URL(string:urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod=httpMethod.rawValue
        request=self.setRequestHeader(request: request)
        
        if let input=input {
            let json=try? JSONEncoder().encode(input)
            if let json=json {
//                print("Input json : \(json)")
//                printData(data: json)
                request.httpBody=json
            }
        }
        
        let config=URLSessionConfiguration.default
        let session=URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task=session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                if error.code == NSURLErrorCancelled {
                    //cancelled
                    print("Request Cancelled")
                    return
                }
            }
            
            complitionHandler(data,response,error)
            
        }
        task.resume()
    }
    
    static func request<InputCodable:Codable>(url urlString:String,httpMethod:HttpCallMethod,input:InputCodable?,sessions:inout [URLSession?],tasks:inout [URLSessionDataTask?],complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        guard let url=URL(string:urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod=httpMethod.rawValue
        request=self.setRequestHeader(request: request)
        
        if let input=input {
            let json=try? JSONEncoder().encode(input)
            if let json=json {
                //                print("Input json : \(json)")
//                printData(data: json)
                request.httpBody=json
            }
        }
        
        let config=URLSessionConfiguration.default
        let session=URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task=session.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                if error.code == NSURLErrorCancelled {
                    //cancelled
                    print("Request Cancelled")
                    return
                }
            }
            
            complitionHandler(data,response,error)
            
        }
        
        sessions.append(session)
        tasks.append(task)
        task.resume()
    }
    
    
    static func uploadImage(url urlString:String,image:UIImage?,sessions:inout [URLSession?],tasks:inout [URLSessionUploadTask?],delegate:URLSessionDelegate,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        guard let url=URL(string:urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod=HttpCallMethod.POST.rawValue
        request=self.setRequestHeader(request: request)
        
        request.setValue("file.jpg", forHTTPHeaderField: "fileName")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var imageData:Data?
        if let image=image {
            imageData=image.jpegData(compressionQuality: 1)
        }
        guard let dataToSend=imageData else {
            return
        }
        
        
        let config=URLSessionConfiguration.default
        let session=URLSession(configuration: config, delegate: delegate, delegateQueue: OperationQueue.main)
        
        let task=session.uploadTask(with: request, from: dataToSend) { (data, response, error) in
            
            if let error = error as NSError? {
                if error.code == NSURLErrorCancelled {
                    //cancelled
                    print("Request Cancelled")
                    return
                }
            }
            
            complitionHandler(data,response,error)
        }
        
        sessions.append(session)
        tasks.append(task)
        task.resume()
    }
    
    //MARK: - Utilities
    
    static func readJsonData<JsonType:Codable>(data:Data?,outputType:JsonType.Type)->JsonType? {
        guard let data=data else {
            return nil
        }
        let output=try? JSONDecoder().decode(outputType, from: data)
        return output
    }
    
    static func stopAndClearRequests(sessions:inout [URLSession?],tasks: inout [URLSessionDataTask?]){
        
        for task in tasks {
            task?.cancel()
        }
        for session in sessions {
            session?.invalidateAndCancel()
        }
        tasks=[]
        sessions=[]
    }
    
    static func stopAndClearUploadRequests(sessions:inout [URLSession?],tasks: inout [URLSessionUploadTask?]){
        
        for task in tasks {
            task?.cancel()
        }
        for session in sessions {
            session?.invalidateAndCancel()
        }
        tasks=[]
        sessions=[]
    }
    
    
    static func printData(data:Data?) {
        guard let data=data else {
            return
        }
        if let dataString=String(data: data, encoding: .utf8) {
            print(dataString)
        }
    }
}
