//
//  CategoryInput.swift
//  app
//
//  Created by Amir Hossein on 2/27/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import Foundation

class CategoryInput: Codable {
    var countryId: Int
    
    init(countryId: Int) {
        self.countryId = countryId
    }
}
