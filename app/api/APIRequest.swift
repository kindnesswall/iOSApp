import Foundation
import UIKit
import KeychainSwift
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
    
    public static func requestFormUrlEncoded(
        url:String,
        formKeyValueInput:[String:String],
        httpMethod:EnumHttpMethods,
        completionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let headers = ["content-type": "application/x-www-form-urlencoded"]
        
        let postData = NSMutableData()
        for (key,value) in formKeyValueInput{
            postData.append(("&" + key + "=" + value).data(using: String.Encoding.utf8)!)
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = httpMethod.value
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil else{
                print(error)
                return
            }
            
            completionHandler(data, response, error)
            
            
//            let httpResponse = response as? HTTPURLResponse
//            print(httpResponse)
            
        })
        
        dataTask.resume()
    }
    
    public static func Request(url:String,httpMethod:EnumHttpMethods,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            
            request.httpMethod = httpMethod.value
            
            request=self.setRequestHeader(request: request)
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                complitionHandler(data, response, error)
            })
            task.resume()
        }
    }
    
    public static func setRequestHeader(request:URLRequest)->URLRequest
    {
        var returnRequest=request
        returnRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let keychain = KeychainSwift()
//        let userDefault = UserDefaults.standard
        if let token = keychain.get(AppConstants.Authorization) {
            returnRequest.setValue(token, forHTTPHeaderField: AppConstants.Authorization)
            print("token: \(token)")
        }
        return returnRequest
        
    }
    
    public static func request(url:String,httpMethod:EnumHttpMethods = .post,inputDictionary:[String:Any]?,complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            
            request.httpMethod = httpMethod.value
            
            request=self.setRequestHeader(request: request)
            
            
            
            if let inputDictionary=inputDictionary {
                
                let json=try! JSONSerialization.data(withJSONObject: inputDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                print("input json:")
                APIRequest.logReply(data: json)
                request.httpBody=json
            }
            
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error as NSError? {
                    if error.code == NSURLErrorCancelled {
                        //cancelled
                        print("Request Cancelled")
                        return
                    }
                }
                
                complitionHandler(data, response, error)
            })
            task.resume()
            
        }
        
    }
    
    
    
    public static func request(
        url:String,
        httpMethod:EnumHttpMethods = .post,
        appendToSessions sessions: inout [Foundation.URLSession?],
        appendToTasks tasks: inout [URLSessionDataTask?],
        inputDictionary:[String:Any]?,
        complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void){
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            
            request.httpMethod = httpMethod.value
            
            request=self.setRequestHeader(request: request)
            
            
            
            if let inputDictionary=inputDictionary {
                
                let json=try! JSONSerialization.data(withJSONObject: inputDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                print("input json:")
                APIRequest.logReply(data: json)
                request.httpBody=json
            }
            
            
            
            
            let config = URLSessionConfiguration.default
            let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
            let task=session.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if let error = error as NSError? {
                    if error.code == NSURLErrorCancelled {
                        //cancelled
                        print("Request Cancelled")
                        return
                    }
                }
                
                complitionHandler(data, response, error)
            })
            
            
            sessions.append(session)
            tasks.append(task)
            task.resume()
            
        }
        
    }
    
//    public static func getJsonDic(fromData data:Data?)->[String:Any]?{
//
//        if let data=data {
//            let json:[String:Any]??
//
//            json=try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:Any]
//            if let json=json {
//                return json
//            }
//
//        }
//        return nil
//    }
    
    
    //MARK: - Upload
    
    public static func uploadImageTask(
        url:String,
        session:inout Foundation.URLSession?,
        task: inout URLSessionDataTask?,
        delegate:URLSessionDelegate,
        image:UIImage?,
        complitionHandler:@escaping (Data?,URLResponse?,Error?)->Void)
    {
        
        task?.cancel()
        session?.invalidateAndCancel()
        
        let mainURL=URL(string: url)
        
        if let mainURL=mainURL {
            var request = URLRequest(url: mainURL)
            request.httpMethod="POST"
            
            request=self.setRequestHeader(request: request)
            
            request.setValue("file.jpg", forHTTPHeaderField: "fileName")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var dataToSend:Data?
            
            if let image=image {
                
                let imageData=image.jpegData(compressionQuality: 1)
                
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
    
    public static func readJsonData<JsonType:Codable>(data:Data?,outputType:JsonType.Type)->JsonType? {
        
        if let data=data {
            let decoder = JSONDecoder()
            let reply = try? decoder.decode(outputType, from: data)
            return reply
        }
        return nil
    }
    
    
    //Read test Json
    
    public static func requestTestJson(name:String,complitionHandler: @escaping(Data?)->Void){
        
        if let file = Bundle.main.url(forResource: name, withExtension: "json") {
            let data = try? Data(contentsOf: file)
            complitionHandler(data)
            
        }else{
            print("file not found")
        }
    }
    
    
    public static func stopAndClearSessionsAndTasks(sessions:inout [URLSession?],tasks: inout [URLSessionDataTask?]){
        for task in tasks {
            task?.cancel()
        }
        for session in sessions {
            session?.invalidateAndCancel()
        }
        tasks=[]
        sessions=[]
    }
    
    //MARK: - Else
    
    public static func logReply(data:Data?){
        if let data=data {
            let log=String(data: data, encoding: .utf8)
            if let log=log {
                print(log)
                
            }
            
        }
    }
    
    
    
}
