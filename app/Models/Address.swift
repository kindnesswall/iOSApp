//
//  Address.swift
//  app
//
//  Created by Hamed.Gh on 12/31/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class Address {
    var address: String {
        var address = ""
        if let province = province {
            address = LanguageKeys.province.localizedString + ": " + province + ", "
        }
        if let city = city {
            address += LanguageKeys.city.localizedString + ": " + city
        }
        if let region = region {
            address += LanguageKeys.region.localizedString + ": " + region
        }
        return address
    }
    var province: String?
    var city: String?
    var region: String?

    var provinceId: Int?
    var cityId: Int?
    var regionId: Int?

    init(province: Place?, city: Place?, region: Place?) {
        self.province=province?.name
        self.provinceId=province?.id
        self.city=city?.name
        self.cityId=city?.id
        self.region=region?.name
        self.regionId=region?.id
    }

    init(province: String?, city: String?, region: String?) {
        self.province=province
        self.city=city
        self.region=region
    }
}
