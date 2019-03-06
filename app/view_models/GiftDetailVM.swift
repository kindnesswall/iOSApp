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
}

