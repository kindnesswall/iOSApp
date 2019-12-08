//
//  URLBrowser.swift
//  app
//
//  Created by Amir Hossein on 12/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

class URLBrowser {

    var urlAddress: String
    init(urlAddress: String) {
        self.urlAddress = urlAddress
    }

    func openURL() {

        guard let url = URL(string: urlAddress) else {
            showErrorMessage()
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func showErrorMessage() {
        print("Can not open the url with address: \(urlAddress)")
    }
}
