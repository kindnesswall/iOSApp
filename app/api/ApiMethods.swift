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
    
    
    
    static func getChatConversation(chatId:Int,startIndex:Int, complitionHandler:@escaping (ChatConversationOutput)->Void) {
        
        APIRequest.request(
            url: APIURLs.getChatConversation,
            inputDictionary: ["chat_id":chatId, "start_index":startIndex, "last_index":startIndex + offset - 1 ])
        {(data, response, error) in
            
            ApiUtility.watch(data: data)
            
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
            
            ApiUtility.watch(data: data)
            
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
    
//    public static func getRecievedRequestList(giftId:String, startIndex:Int, completionHandler:@escaping(Data?,URLResponse?,Error?)->Void) {
//        
//        let mainURL: String =
//            APIURLs.getRecievedRequestList + "/\(giftId)/\(startIndex)/\(startIndex+offset)"
//        
//        APIRequest.Request(url: mainURL, httpMethod: .get, complitionHandler: { (data, response, error) in
//            
//            completionHandler(data, response, error)
//        })
//    }
    
//    public static func logout(completionHandler:@escaping(Data?)->Void) {
//
//        let url:String = APIURLs.logout
//
//        var jsonDicInput : [String : String] = ApiInput.LogoutInput(registeration_id: "")
//
//        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
//
//            APIRequest.logReply(data: data)
//
//            completionHandler(data)
//        }
//    }
    
//    public static func setDevice(completionHandler:@escaping(Data?)->Void) {
//
//        let url:String = APIURLs.setDevice
//
//        var jsonDicInput : [String : String] = ApiInput.SetDeviceInput(registeration_id: "", device_id: "")
//
//        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
//
//            APIRequest.logReply(data: data)
//            completionHandler(data)
//        }
//    }
    
    
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
    
    
//    public static func deleteGift(giftId: String,
//                                  completionHandler:@escaping(Data?)->Void) {
//        let mainURL: String = APIURLs.Gift + "/" + giftId
//
//        APIRequest.Request(url: mainURL, httpMethod: .delete, complitionHandler: { (data, response, error) in
//
//            APIRequest.logReply(data: data)
//            guard error == nil else {
//                print("Get error register")
//                return
//            }
//            completionHandler(data)
//        })
//    }
    
//    public static func deleteMyRequest(giftId: String,
//                                       completionHandler:@escaping(Data?)->Void) {
//        let mainURL: String = APIURLs.deleteMyRequest + "/" + giftId
//
//        APIRequest.Request(url: mainURL, httpMethod: .delete, complitionHandler: { (data, response, error) in
//
//            APIRequest.logReply(data: data)
//            guard error == nil else {
//                print("Get error register")
//                return
//            }
//            completionHandler(data)
//        })
//    }
    
    public static func acceptRequest(giftId: String,
                                     fromUserId : String,
                                       completionHandler:@escaping(Data?)->Void) {
        
        let mainURL: String = APIURLs.acceptRequest + giftId + "/" + fromUserId
        
        APIRequest.Request(url: mainURL, httpMethod: .put, complitionHandler: { (data, response, error) in
            
            ApiUtility.watch(data: data)
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
            
            ApiUtility.watch(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
//    public static func bookmark(giftId: String, completionHandler:@escaping(Data?)->Void) {
//        
//        let url:String = APIURLs.bookmark
//        
//        var jsonDicInput : [String : String] = ApiInput.BookmarkInput(giftId: giftId)
//        
//        APIRequest.request(url: url, inputDictionary: jsonDicInput) { (data, response, error) in
//            
//            APIRequest.logReply(data: data)
//            guard error == nil else {
//                print("Get error register")
//                return
//            }
//            completionHandler(data)
//        }
//    }
    
    public func clearAllTasksAndSessions(){
        APIRequest.stopAndClearSessionsAndTasks(sessions: &self.sessions, tasks: &self.tasks)
    }
    
    
}
