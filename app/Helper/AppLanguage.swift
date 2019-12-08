//
//  AppLanguage.swift
//  app
//
//  Created by AmirHossein on 3/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

extension String {
    var localizedNumber: String {
        return AppLanguage.getNumberString(number: self)
    }
}

extension Int {
    var localizedNumber: String {
        return self.description.localizedNumber
    }
}

class AppLanguage {

    static let English: String = "en"
    static let Persian: String = "fa"

    static func getLanguage() -> String {

        if LocalizationSystem.sharedInstance.getLanguage() == Persian {
            return Persian
        } else {
            return English
        }
    }

    // MARK: - Utilities

    static func getNumberString(number: String) -> String {
        let language = AppLanguage.getLanguage()

        switch language {
        case Persian:
            return number.castNumberToPersian()
        case English:
            return number
        default:
            return number
        }
    }

    static func getTextAlignment() -> NSTextAlignment {
        let language = AppLanguage.getLanguage()
        switch language {
        case Persian:
            return .right
        case English:
            return .left
        default:
            return .left
        }
    }

}
