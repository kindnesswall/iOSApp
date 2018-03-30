//
//  ApiMethods.swift
//  app
//
//  Created by Hamed.Gh on 11/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class ApiMethods {
    
    public static let offset:Int = 15
    
    var sessions:[URLSession?]=[]
    var tasks:[URLSessionDataTask?]=[]
    
    
    public func getCategories(completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
        
        var url=APIURLs.getCategories
        url+="/0/1000/1"
        
        APIRequest.requestFormUrlEncoded(url: url, formKeyValueInput: [:], httpMethod: .get) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(data, response, error)
            }
            
        }
    }
        
    public static func login(mobile:String, verificationCode:String, completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
        
        let regId:String = "eoFH_ujJBxU:APA91bEEEAv1RpiP4RHzwJLEa9bRFdAi1sTIgFV9GScwfDNcmDucVFkWG0EstL5I5zNVaFqCVT3NMiBUjhtyQEFUM89S9tXf44u0N4LhozYv1KWNcGkyCMeUEmcOYRYEiu5gud18h_A"
        let deviceId:String = "352136066349321"
        
        var formKeyValue:[String:String] = [
            APIMethodDictionaryKey.Username:mobile,
            APIMethodDictionaryKey.Password:verificationCode,
            APIMethodDictionaryKey.RegisterationId:regId,
            APIMethodDictionaryKey.DeviceId:deviceId,
            "grant_type":"password"]
        
        let url:String = APIURLs.login
        
        APIRequest.requestFormUrlEncoded(url: url, formKeyValueInput: formKeyValue, httpMethod: .post) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    static func getChatConversation(chatId:Int,startIndex:Int, complitionHandler:@escaping (ChatConversationOutput)->Void) {
        
        APIRequest.request(
            url: APIURLs.getChatConversation,
            inputDictionary: ["chat_id":chatId, "start_index":startIndex, "last_index":startIndex + offset - 1 ])
        {(data, response, error) in
            
            APIRequest.logReply(data: data)
            
//            if let reply=APIRequest.readJsonData(
//                data: data,
//                outputType: ChatConversationOutput.self) {
//                
//                if let status=reply.status,status==APIStatus.DONE {
//                    
//                    complitionHandler(reply)
//                    
//                }
//            }
        }
    }
    
    static func sendMessage(chatId:Int, messageText:String, complitionHandler:@escaping (Int)->Void){
        
        APIRequest.request(
            url: APIURLs.sendMessage,
            inputDictionary: ["chat_id":chatId, "message_text":messageText ])
        {(data, response, error) in
            
            APIRequest.logReply(data: data)
            
//            if let reply=APIRequest.readJsonData(
//                data: data,
//                outputType: StatusOutput.self) {
//                
//                if let status=reply.status {
//                    
//                    complitionHandler(status)
//                    
//                }
//            }
        }
        
    }
    
    public static func getRequestsMyGifts(startIndex:Int, completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
        
        let mainURL: String = APIURLs.getRequestsMyGifts + "/" + "\(startIndex)/\(startIndex+offset)"
        
        APIRequest.Request(url: mainURL, httpMethod: .get, complitionHandler: { (data, response, error) in
            
            completionHandler(data, response, error)
        })
    }
    
    public static func getRecievedRequestList(giftId:String, startIndex:Int, completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
        
        let mainURL: String =
            APIURLs.getRecievedRequestList + "/\(giftId)/\(startIndex)/\(startIndex+offset)"
        
        APIRequest.Request(url: mainURL, httpMethod: .get, complitionHandler: { (data, response, error) in
            
            completionHandler(data, response, error)
        })
    }
    
    public static func register(telephone:String, completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
        
        let mainURL: String = APIURLs.register + telephone
        
        APIRequest.Request(url: mainURL, httpMethod: .post, complitionHandler: { (data, response, error) in
            
            completionHandler(data, response, error)
        })
    }
    
    public static func logout(completionHandler:@escaping(Data?)->Void) {
        
        let url:String = APIURLs.logout

        var jsonDicInput : [String : String] = ApiInput.LogoutInput(registeration_id: "")
        
        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            
            completionHandler(data)
        }
    }
    
    public static func setDevice(completionHandler:@escaping(Data?)->Void) {
        
        let url:String = APIURLs.setDevice
        
        var jsonDicInput : [String : String] = ApiInput.SetDeviceInput(registeration_id: "", device_id: "")
        
        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            completionHandler(data)
        }
    }
    
    public func getGifts(
        cityId:String,
        regionId:String?,
        categoryId:String?,
        startIndex:Int,
        lastIndex:Int,
        searchText:String?,
        completionHandler:@escaping(Data?)->Void) {
        
        let regionId = regionId ?? "0"
        let categoryId = categoryId ?? "0"
//        let lastIndex = startIndex + offset
        let searchText = "/?searchText=" + (searchText ?? "")
        let mainURL: String = APIURLs.Gift + "/" + cityId + "/" + regionId + "/" + categoryId + "/" + "\(startIndex)/" + "\(lastIndex)" + searchText
        
        APIRequest.request(url: mainURL, httpMethod: .get, appendToSessions: &self.sessions, appendToTasks: &self.tasks, inputDictionary: nil) { (data, response, error) in
            
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        }
        
    }
    
    public static func getGift(
        giftId:String,
        completionHandler:@escaping(Data?)->Void) {
        
        let mainURL: String = APIURLs.Gift + "/" + giftId
        
        APIRequest.Request(url: mainURL, httpMethod: .get, complitionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    
    public static func deleteGift(giftId: String,
                                  completionHandler:@escaping(Data?)->Void) {
        let mainURL: String = APIURLs.Gift + "/" + giftId
        
        APIRequest.Request(url: mainURL, httpMethod: .delete, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    public static func deleteMyRequest(giftId: String,
                                       completionHandler:@escaping(Data?)->Void) {
        let mainURL: String = APIURLs.deleteMyRequest + "/" + giftId
        
        APIRequest.Request(url: mainURL, httpMethod: .delete, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    public static func acceptRequest(giftId: String,
                                     fromUserId : String,
                                       completionHandler:@escaping(Data?)->Void) {
        
        let mainURL: String = APIURLs.acceptRequest + giftId + "/" + fromUserId
        
        APIRequest.Request(url: mainURL, httpMethod: .put, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    public static func denyRequest(giftId: String,
                                     fromUserId : String,
                                     completionHandler:@escaping(Data?)->Void) {
        
        let mainURL: String = APIURLs.denyRequest + giftId + "/" + fromUserId
        
        APIRequest.Request(url: mainURL, httpMethod: .put, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    public static func bookmark(giftId: String, completionHandler:@escaping(Data?)->Void) {
        
        let url:String = APIURLs.bookmark
        
        var jsonDicInput : [String : String] = ApiInput.BookmarkInput(giftId: giftId)
        
        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        }
    }
    
    public func clearAllTasksAndSessions(){
        APIRequest.stopAndClearSessionsAndTasks(sessions: &self.sessions, tasks: &self.tasks)
    }
    
    
}
