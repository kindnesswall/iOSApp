//
//  String + ConvertToDate.swift
//  app
//
//  Created by Amir Hossein on 5/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation


extension String {
    func convertToDate()->Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: self)
        return date
    }
}
