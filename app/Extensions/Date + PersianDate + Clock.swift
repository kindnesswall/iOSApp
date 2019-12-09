//
//  Date + PersianDate + Clock.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/20/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation

extension Date {
    func getPersianDate() -> String {
        let calendar = Calendar(identifier: .persian)
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let persianDate = "\(year)/\(month)/\(day)"
        return persianDate
    }

    func getClock() -> String {
        let calendar = Calendar(identifier: .persian)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)

        let hourString = hour<10 ? "0\(hour)" : "\(hour)"
        let minuteString = minute<10 ? "0\(minute)" : "\(minute)"

        let clockString = "\(hourString):\(minuteString)"
        return clockString
    }

}
