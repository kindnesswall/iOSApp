//
//  String+numbers.swift
//  iptv
//
//  Created by maede on 1/31/18.
//  Copyright © 2018 aseman. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    public func CastNumberToPersian()->String{
        
        var number=self
        
        number=number.replacingOccurrences(of: "0", with: "۰")
        number=number.replacingOccurrences(of: "1", with: "۱")
        number=number.replacingOccurrences(of: "2", with: "۲")
        number=number.replacingOccurrences(of: "3", with: "۳")
        number=number.replacingOccurrences(of: "4", with: "۴")
        number=number.replacingOccurrences(of: "5", with: "۵")
        number=number.replacingOccurrences(of: "6", with: "۶")
        number=number.replacingOccurrences(of: "7", with: "۷")
        number=number.replacingOccurrences(of: "8", with: "۸")
        number=number.replacingOccurrences(of: "9", with: "۹")
        
        return number
    }
   
    public func castNumberToPersianLetterText()->String{
        
        var number = self
        number=number.replacingOccurrences(of: "0", with: "اول")
        number=number.replacingOccurrences(of: "1", with: "دوم")
        number=number.replacingOccurrences(of: "2", with: "سوم")
        number=number.replacingOccurrences(of: "3", with: "چهارم")
        number=number.replacingOccurrences(of: "4", with: "پنجم")
        number=number.replacingOccurrences(of: "5", with: "ششم")
        number=number.replacingOccurrences(of: "6", with: "هفتم")
        number=number.replacingOccurrences(of: "7", with: "هشتم")
        number=number.replacingOccurrences(of: "8", with: "نهم")
        number=number.replacingOccurrences(of: "9", with: "دهم")
        
        return number
    }
    
}
