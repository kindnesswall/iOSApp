//
//  AppFont.swift
//  MatchMaking
//
//  Created by Amir Hossein on 10/8/17.
//  Copyright © 2017 aseman. All rights reserved.
//

import Foundation
import UIKit

class AppFont {
    static func getRegularFont(size:CGFloat)->UIFont {
        return UIFont(name: "IranSans", size: size)!
    }
    static func getLightFont(size:CGFloat)->UIFont {
        return UIFont(name: "IranSans-Light", size: size)!
    }
    static func getBoldFont(size:CGFloat)->UIFont {
        return UIFont(name: "IranSans-Bold", size: size)!
    }
}
