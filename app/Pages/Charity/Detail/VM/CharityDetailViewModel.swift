//
//  CharityDetailViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 01.09.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class CharityDetailViewModel: NSObject {
    var charity: Charity
    init(charity: Charity) {
        self.charity = charity
    }

    func callTelephone() {
        if let telephone = charity.telephoneNumber {
            dialNumber(number: telephone)
        }
    }

    func callMobile() {
        if let mobile = charity.mobileNumber {
            dialNumber(number: mobile)
        }
    }

    func openWebsite() {
        if let link = charity.website {
            open(link)
        }
    }

    func openTwitter() {
        if let link = charity.twitter {
            open(link)
        }
    }

    func openEmail() {
        if let link = charity.email {
            open(link)
        }
    }

    func openTelegram() {
        if let link = charity.telegram {
            open(link)
        }
    }

    func openInstagram() {
        if let link = charity.instagram {
            open(link)
        }
    }

    private func open(_ link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func dialNumber(number: String) {
        if let phoneCallURL = URL(string: "tel://" + number), UIApplication.shared.canOpenURL(phoneCallURL) {
                UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }

}
