//
//  AppCountry.swift
//  app
//
//  Created by Amir Hossein on 11/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class AppCountry {

    // MARK: - Default
    private static let defaultCountry = AppConst.Country.iran
    // MARK: - Get
    static var getCurrent: AppConst.Country {

        guard let rawValue = loadCurrent(),
              let current = AppConst.Country(rawValue: rawValue)
        else {
            return defaultCountry
        }

        return current
    }

    static var isNotSelectedAnyCountry: Bool {
        return loadCurrent() == nil
    }

    private static func loadCurrent() -> String? {
        return UserDefaultService().getString(.selectedCountry)
    }

    // MARK: - Set
    static func setCountry(current: AppConst.Country) {
        UserDefaultService().set(.selectedCountry, value: current.rawValue)
    }

    // MARK: - Attributes

    static func getText(country: AppConst.Country = getCurrent) -> String {
        switch country {
        case .iran:
            return "Iran"
        case .german:
            return "German"
        case .others:
            return "Others"
        }
    }

    static func getPhoneCode(country: AppConst.Country = getCurrent) -> String? {
        switch country {
        case .iran:
            return "98"
        case .german:
            return "49"
        case .others:
            return nil
        }
    }

}
