//
//  UIFont+printAllFonts.swift
//  app
//
//  Created by Hamed.Gh on 12/8/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    public static func printAllFonts() {
    
        for familyName:String in UIFont.familyNames {
            print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                print("--Font Name: \(fontName)")
            }
        }
        
    }
    
}
