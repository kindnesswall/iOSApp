//
//  APICall.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class APICall {
    
    public static let OKStatus = 200
    
    static func setRequestHeader(request:URLRequest)->URLRequest {
        var newRequest=request
        newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authorization=KeychainSwift().get(AppConst.KeyChain.Authorization) {
            newRequest.setValue(authorization, forHTTPHeaderField: AppConst.KeyChain.Authorization)
//            print("Authorization: \(authorization)")
        }
        return newRequest
    }
    
    static func uploadImage(url urlString:String,input:ImageInput?,sessions:inout [URLSession],tasks:inout [URLSessionUploadTask],delegate:URLSessionDelegate,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        guard let url=URL(string:urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod=HttpMethod.POST.rawValue
        request=self.setRequestHeader(request: request)
        
        guard let input=input, let dataToSend=try? JSONEncoder().encode(input) else{
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
    
}
