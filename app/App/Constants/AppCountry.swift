//
//  AppCountry.swift
//  app
//
//  Created by Amir Hossein on 11/11/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

class AppCountry {

    // MARK: - Get
    static var country: Country? {
        return loadCurrent()
    }

    static var isNotSelectedAnyCountry: Bool {
        return loadCurrent() == nil
    }

    private static func loadCurrent() -> Country? {
        guard let data = UserDefaultService().getSelectedContryData() else {
            return nil
        }
        let country = try? JSONDecoder().decode(Country.self, from: data)
        return country
    }
    
    static var isIran: Bool {
        return country?.isFarsi == true
    }
    
    static var countryId: Int? {
        return country?.id
    }
    
    static var phoneCode: String? {
        return country?.phoneCode
    }

    // MARK: - Set
    static func setCountry(_ current: Country) {
        guard let data = try? JSONEncoder().encode(current) else { return }
        UserDefaultService().set(.selectedCountry, value: data)
    }
}
