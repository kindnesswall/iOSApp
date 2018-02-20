//
//  Place.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class Place : Codable{
    
    var id:Int?
    var name:String?
    var container_id:Int?
    
    init() {
        
    }
    
    init(id:Int?,name:String?) {
        self.id=id
        self.name=name
    }
    init(id:Int?,name:String?,container_id:Int?) {
        self.id=id
        self.name=name
        self.container_id=container_id
    }
}

class PlaceResponse : Codable{
    var places:[Place]?
    
}
