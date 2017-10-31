//
//  ApiMethods.swift
//  app
//
//  Created by Hamed.Gh on 11/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class ApiMethods {
    
    public static func login(username:String, password:String, completionHandler:@escaping(Data?)->Void) {
        
        let regId:String = "eoFH_ujJBxU:APA91bEEEAv1RpiP4RHzwJLEa9bRFdAi1sTIgFV9GScwfDNcmDucVFkWG0EstL5I5zNVaFqCVT3NMiBUjhtyQEFUM89S9tXf44u0N4LhozYv1KWNcGkyCMeUEmcOYRYEiu5gud18h_A"
        let deviceId:String = "352136066349321"
        
        var formKeyValue:[String:String] = [
            ApiConstants.Username:username,
            ApiConstants.Password:password,
            ApiConstants.RegisterationId:regId,
            ApiConstants.DeviceId:deviceId,
            "grant_type":"password"]
        
        let url:String = APIURLs.BASE_URL + APIURLs.ACCOUNT + "login"
        
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
    
    public static func deleteGift(giftId: String) {
        let mainURL: String = APIURLs.Gift
        
        APIRequest.Request(url: mainURL, httpMethod: .delete, complitionHandler: { (data, response, error) in
            
            APIRequest.logReply(data: data)
            
        })
    }
    
}
