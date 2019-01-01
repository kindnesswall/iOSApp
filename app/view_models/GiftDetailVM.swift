//
//  GiftDetailVM.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class GiftDetailVM: NSObject {
    func getGift(id:String, onSuccess:@escaping (Gift)->(), onFail:(()->())?) {
        ApiMethods.getGift(giftId: id) { [weak self] (data) in
            if let reply=ApiUtility.convert(data: data, to: Gift.self) {
                
                onSuccess(reply)
            }else{
                onFail?()
            }
        }
    }
    
    func removeGift(id:String, onSuccess:@escaping ()->(), onFail:(()->())?) {
        let input:APIEmptyInput?=nil
        var url=APIURLs.Gift
        url+="/\(id)"
        APICall.request(url: url, httpMethod: .DELETE, input: input) { [weak self] (data, response, error) in
            
            if error != nil {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                onFail?()
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    onSuccess()
                }else{
                    FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.operationFailed),theme: .error)
                    onFail?()
                }
            }
        }
    }
}

