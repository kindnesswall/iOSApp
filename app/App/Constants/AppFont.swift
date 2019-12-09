//
//  AppFont.swift
//  app
//
//  Created by Hamed Ghadirian on 08.12.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
enum FontName {
    case iranSansRegular
    case iranSansLight
    case iranSansBold
    case iranSansMedium
    case icomoon
    case systemBold
    case arial
}

struct AppFont {
    static func get(_ font: FontName, size: CGFloat) -> UIFont {
        switch font {
        case .iranSansRegular:
            return UIFont(name: "IRANSansMobile", size: size) ?? UIFont()
        case .iranSansLight:
            return UIFont(name: "IRANSansMobile-Light", size: size) ?? UIFont()
        case .iranSansBold:
            return UIFont(name: "IRANSansMobile-Bold", size: size) ?? UIFont()
        case .iranSansMedium:
            return UIFont(name: "IRANSansMobile-Medium", size: size) ?? UIFont()
        case .icomoon:
            return UIFont(name: "icomoon", size: size)!
        case .systemBold:
            return UIFont.boldSystemFont(ofSize: size)
        case .arial:
            return UIFont(name: "Arial", size: size) ?? UIFont()
        }
    }
}
