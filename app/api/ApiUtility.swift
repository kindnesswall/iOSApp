//
//  ApiUtility.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class ApiUtility {
    public static func convert<JsonType:Codable>(dic:[String:Any]?,to outputType:JsonType.Type)->JsonType? {
        
        guard let dic = dic else{
            return nil
        }
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: dic,options: .prettyPrinted) else {
            return nil
        }
        return convert(data: theJSONData, to: outputType)
        
    }
    
    public static func convert<JsonType:Codable>(data:Data?,to outputType:JsonType.Type)->JsonType? {
        
        if let data=data {
            let decoder = JSONDecoder()
            do{
                let reply = try decoder.decode(outputType, from: data)
                return reply
            }catch let err {
                print("decoding error: \(err)")
            }
        }
        return nil
        
    }
    
    public static func watch(data:Data?){
        if let data=data {
            let log=String(data: data, encoding: .utf8)
            if let log=log {
                print(log)
                
            }
            
        }
    }
}

