//
//  GiftDetailVM.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftDetailVM: NSObject {
    
    func removeGift(id:Int, onSuccess:@escaping ()->(), onFail:(()->())?) {
        let input:APIEmptyInput?=nil
        var url=URIs().gifts
        url+="/\(id)"
        APICall.request(url: url, httpMethod: .DELETE, input: input) {(data, response, error) in
            
            if error != nil {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                onFail?()
                return
            }
            
            guard let response = response as? HTTPURLResponse , response.statusCode == APICall.OKStatus else {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                onFail?()
                return
            }
            
            onSuccess()
        }
    }
    
    func requestGift(id:Int,onSuccess:@escaping (Int)->(), onFail:(()->())?) {
        let input:APIEmptyInput? = nil
        let url = "\(URIs().gifts_request)/\(id)"
        
        APICall.request(url: url, httpMethod: .GET, input: input) { (data, response, error) in
            guard error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == APICall.OKStatus,
                let chat = APICall.readJsonData(data: data, outputType: Chat.self),
                let chatId = chat.id
                else {
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                    onFail?()
                    return
            }
            
            onSuccess(chatId)
            
        }
    }
}
