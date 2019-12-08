//
//  AppFont.swift
//  app
//
//  Created by Hamed Ghadirian on 08.12.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

struct AppFont {
    static func getRegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "IRANSansMobile", size: size)!
    }
    static func getLightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "IRANSansMobile-Light", size: size)!
    }
    static func getBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "IRANSansMobile-Bold", size: size)!
    }
    static func getIcomoonFont(size: CGFloat) -> UIFont {
        return UIFont(name: "icomoon", size: size)!
    }
}
