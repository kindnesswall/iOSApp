//
//  Public Functions.swift
//  app
//
//  Created by Hamed.Gh on 12/31/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

public func getUniqeNameWith(fileExtension:String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd"
    let fileName = NSUUID().uuidString + dateFormatterGet.string(from: Date()) + fileExtension
    return fileName
}
