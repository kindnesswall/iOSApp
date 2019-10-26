//
//  Province.swift
//  App
//
//  Created by Amir Hossein on 2/8/19.
//

import Foundation


final class Province: Codable {
    var id:Int?
    var name:String?
    
    init(id:Int?,name:String?) {
        self.id=id
        self.name=name
    }
}
