//
//  ResponseModel.swift
//  VC
//
//  Created by Amir Hossein on 10/11/17.
//  Copyright © 2017 Aseman. All rights reserved.
//

import Foundation

class ResponseModel<Model:Codable> : Codable {
    var status:Int?
    var result:Model?
}

class DictionaryResponseModel<Model:Codable> : Codable {
    var status:Int?
    var result:[String:Model]?
    
    func getResult(name:String)->Model?{
        return self.result?[name]
    }
}
