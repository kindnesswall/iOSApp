//
//  Category.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation

class Category: Codable {
    
//    var imageUrl:String?
    var title:String?
    var id:Int?
    
    init(id:Int?,title:String?) {
        self.id=id
        self.title=title
    }
}

