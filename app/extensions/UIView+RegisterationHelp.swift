//
//  UIView+RegisterationHelp.swift
//  ResanehAval
//
//  Created by Amir Hossein on 2/21/18.
//  Copyright © 2018 Aseman. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle(for:self)
    }
}

extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    static var bundle: Bundle {
        return Bundle(for:self)
    }
}
