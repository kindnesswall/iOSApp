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
        
    public static func login(username:String, password:String, completionHandler:@escaping(Data?)->Void) {
        
        let regId:String = "eoFH_ujJBxU:APA91bEEEAv1RpiP4RHzwJLEa9bRFdAi1sTIgFV9GScwfDNcmDucVFkWG0EstL5I5zNVaFqCVT3NMiBUjhtyQEFUM89S9tXf44u0N4LhozYv1KWNcGkyCMeUEmcOYRYEiu5gud18h_A"
        let deviceId:String = "352136066349321"
        
        var formKeyValue:[String:String] = [
            ApiConstants.Username:username,
            ApiConstants.Password:password,
            ApiConstants.RegisterationId:regId,
            ApiConstants.DeviceId:deviceId,
            "grant_type":"password"]
        
        let url:String = APIURLs.login
        
        APIRequest.requestFormUrlEncoded(url: url, formKeyValueInput: formKeyValue, httpMethod: .post) { (data) in
            completionHandler(data)
        }
        
    }
    
    public static func register(telephone:String, completionHandler:@escaping(Data?)->Void) {
        
        let mainURL: String = APIURLs.register + telephone
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(telephone, forKey: ApiConstants.Phone)
        userDefaults.synchronize()
        
        APIRequest.Request(url: mainURL, httpMethod: .post, complitionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
    }
    
    public static func logout(completionHandler:@escaping(Data?)->Void) {
        
        let url:String = APIURLs.logout

        var jsonDicInput : [String : String] = ApiInput.LogoutInput(registeration_id: "")
        
        APIRequest.request(url: url, inputJson: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            
            completionHandler(data)
        }
    }
    
    public static func setDevice(completionHandler:@escaping(Data?)->Void) {
        
        let url:String = APIURLs.setDevice
        
        var jsonDicInput : [String : String] = ApiInput.SetDeviceInput(registeration_id: "", device_id: "")
        
        APIRequest.request(url: url, inputJson: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            completionHandler(data)
        }
    }
    
    public static func getGifts(
        cityId:String,
        regionId:String?,
        categoryId:String?,
        startIndex:Int,
        searchText:String?,
        completionHandler:@escaping(Data?)->Void) {
        
        let regionId = regionId ?? "0"
        let categoryId = categoryId ?? "0"
        let lastIndex = startIndex + offset
        let searchText = "/?searchText=" + (searchText ?? "")
        let mainURL: String = APIURLs.Gift + "/" + cityId + "/" + regionId + "/" + categoryId + "/" + "\(startIndex)/" + "\(lastIndex)" + searchText
        
        APIRequest.Request(url: mainURL, httpMethod: .get, complitionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        })
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
        
        APIRequest.request(url: url, inputJson: jsonDicInput) { (data, response, error) in
            
            APIRequest.logReply(data: data)
            guard error == nil else {
                print("Get error register")
                return
            }
            completionHandler(data)
        }
    }
}
