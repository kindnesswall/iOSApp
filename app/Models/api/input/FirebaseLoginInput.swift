//
//  FirebaseLoginInput.swift
//  app
//
//  Created by Amir Hossein on 11/9/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class FirebaseLoginInput: Codable {
    var idToken: String

    init(idToken: String) {
        self.idToken = idToken
    }
}
