//
//  ReadData.swift
//  VOD_Project
//
//  Created by AmirHossein on 5/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
//import Toaster

enum EnumHttpMethods:String {
    
    case post
    case get
    case put
    case delete
    
    var value:String {
        switch self {
        case .post:
            return "POST"
        case .get:
            return "GET"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        default:
            return "GET"
        }
    }
}

class APIRequest {
    
    //MARK: - json request
    
    
    public static func setRequestHeader(request:URLRequest)->URLRequest
    {
        var returnRequest=request
        returnRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return returnRequest

    }
    
    public static func Request(url:String,token:String?,httpMethod:EnumHttpMethods,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            
            request.httpMethod = httpMethod.value
            
            request=self.setRequestHeader(request: request)
            
            if let token=token {
                request.setValue(token, forHTTPHeaderField: "token")
            }
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                complitionHandler(data, response, error)
            })
            task.resume()
        }
    }
    
    public static func request(url:String,token:String?,inputJson:[String:Any]?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="POST"
            
            request=self.setRequestHeader(request: request)
            
            if let token=token {
                request.setValue(token, forHTTPHeaderField: "token")
                
            }
            if let inputJson=inputJson {
                
                let json=try! JSONSerialization.data(withJSONObject: inputJson, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                request.httpBody=json
            }
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                complitionHandler(data, response, error)
            })
            task.resume()
            
        }
        
    }
    
    public static func request(url:String,session:inout Foundation.URLSession?, task: inout URLSessionDataTask?,token:String?,inputJson:[String:Any]?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        task?.cancel()
        session?.invalidateAndCancel()
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="POST"
            
            request=self.setRequestHeader(request: request)
            
            if let token=token {
                request.setValue(token, forHTTPHeaderField: "token")
                
            }
            if let inputJson=inputJson {
                
                let json=try! JSONSerialization.data(withJSONObject: inputJson, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                request.httpBody=json
            }
            
            
            let config = URLSessionConfiguration.default
            session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            task=session?.dataTask(with: request, completionHandler: { (data, response, error) in
                complitionHandler(data, response, error)
            })

            task?.resume()
            
        }
        
    }


    public static func request(url:String,appendToSessions sessions: inout [Foundation.URLSession?], appendToTasks tasks: inout [URLSessionDataTask?],token:String?,inputJson:[String:Any]?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="POST"
            
            request=self.setRequestHeader(request: request)
            
            if let token=token {
                request.setValue(token, forHTTPHeaderField: "token")
                
            }
            
            if let inputJson=inputJson {
                
                let json=try! JSONSerialization.data(withJSONObject: inputJson, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                request.httpBody=json
            }
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                complitionHandler(data, response, error)
            })

            
            sessions.append(session)
            tasks.append(task)
            task.resume()
            
        }
        
    }
    
    public static func getJsonDic(fromData data:Data?)->[String:Any]?{
        
        if let data=data {
            let json:[String:Any]??
            
            json=try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any]
            if let json=json {
                return json
            }
            
        }
        return nil
    }
    
    public static func getJsonArray(fromData data:Data?)->[Any]?{
        
        if let data=data {
            
            let json:[Any]??
            
            json=try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [Any]
            if let json=json {
                return json
            }
            
        }
        return nil
    }

    
    //MARK: - image
    
    public static func readImage(url:String,appendToSessions sessions: inout [Foundation.URLSession?], appendToTasks tasks: inout [URLSessionDataTask?],complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: complitionHandler)
            
            sessions.append(session)
            tasks.append(task)
            task.resume()
            
        }
    }
    
    public static func readImage(url:String,session:inout Foundation.URLSession?, task: inout URLSessionDataTask?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            
            let config = URLSessionConfiguration.default
            session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            task=session?.dataTask(with: request, completionHandler: complitionHandler)
            task?.resume()
            
        }
    }
    
    public static func readImage(url:String,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: complitionHandler)
            task.resume()
            
        }
    }
    
    public static func getImage(fromData data:Data?)->UIImage? {
        
        if let data=data {
            let image=UIImage(data: data)
            return image
        }
        return nil
        
    }
    
    
    public static func readAndSetImage(url:String,complitionHandler:@escaping(UIImage)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let image=APIRequest.getImage(fromData: data) {
                    complitionHandler(image)
                }
            })
            task.resume()
            
        }
    }
    
    public static func readAndSetImage(url:String,appendToSessions sessions: inout [Foundation.URLSession?], appendToTasks tasks: inout [URLSessionDataTask?],complitionHandler:@escaping(UIImage)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let image=APIRequest.getImage(fromData: data) {
                    complitionHandler(image)
                }
            })
            
            sessions.append(session)
            tasks.append(task)
            task.resume()
            
        }
    }
    
    public static func readAndSetImage(url:String,session:inout Foundation.URLSession?, task: inout URLSessionDataTask?,complitionHandler:@escaping(UIImage)->Void) {
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="GET"
            
            
            let config = URLSessionConfiguration.default
            session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            task=session?.dataTask(with: request, completionHandler: { (data, response, error) in
                if let image=APIRequest.getImage(fromData: data) {
                    complitionHandler(image)
                }
            })
            task?.resume()
            
        }
    }

    


    
    //MARK: - Upload
    
 
    
    public static func uploadImageTask(url:String,session:inout Foundation.URLSession?, task: inout URLSessionDataTask?,delegate:URLSessionDelegate,token:String?,image:UIImage?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        task?.cancel()
        session?.invalidateAndCancel()
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="POST"
            
            if let token=token {
                request.setValue(token, forHTTPHeaderField: "token")
                
            }
            
            
            
            request.setValue("file.jpg", forHTTPHeaderField: "fileName")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var dataToSend:Data?
            
            if let image=image {
                
                let imageData=UIImageJPEGRepresentation(image, 1)
                
                if let imageData=imageData {
                    //                    request.httpBody=imageData
                    dataToSend=imageData
                    
                }
                
                
            }
            
            
            let config = URLSessionConfiguration.default
            session = Foundation.URLSession(configuration: config, delegate: delegate, delegateQueue: OperationQueue.main)
            if let dataToSend=dataToSend {
                task=session?.uploadTask(with: request, from: dataToSend, completionHandler: complitionHandler)
                task?.resume()
            }
            
            
        }
        
    }
    
    
    //Codable
    
    public static func readJsonData<JsonType:Codable>(data:Data?,outpuType:JsonType.Type)->JsonType? {
        
        if let data=data {
            let decoder = JSONDecoder()
            let reply = try? decoder.decode(outpuType, from: data)
            return reply
        }
        return nil
    }

    
    //MARK: - Else
    
    public static func stopAndClearSessionsAndTasks(sessions:inout [Foundation.URLSession?], tasks: inout[URLSessionDataTask?]) {
        for task in tasks {
            task?.cancel()
        }
        for session in sessions {
            session?.invalidateAndCancel()
        }
        
        tasks=[]
        sessions=[]
    }
    
    public static func logReply(data:Data?){
        if let data=data {
            let log=String(data: data, encoding: .utf8)
            if let log=log {
                print(log)

            }
            
        }
    }
    
}
