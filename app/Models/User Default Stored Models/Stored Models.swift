//
//  Draft Models.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class RegisterGiftDraft: Codable {
    var title: String?
    var description: String?
    var price: Int?
    var places: [Place]?
    var category: Category?
    var dateStatus: DateStatus?
}
