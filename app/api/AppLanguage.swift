//
//  AppLanguage.swift
//  app
//
//  Created by AmirHossein on 3/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

class AppLanguage{
    
    static private var language:Language?
    
    enum Language:String {
        case persian
        case english
    }
    
    static func setLanguage(language:Language){
        self.language=language
        KeychainSwift().set(language.rawValue, forKey: AppConstants.APPLanguage)
    }
    static func getLanguage()->Language {
        
        if let language=self.language {
            return language
        }
        
        let defaultLanguage=Language.persian
        
        guard let languageString=KeychainSwift().get(AppConstants.APPLanguage) , let language=Language(rawValue: languageString) else {
            return defaultLanguage
        }
        
        self.language=language
        return language
    }
    
}

class AppLiteral {
    
    static var home : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "خانه"
        case .english:
            return "Home"
        }
    }
    
    static var myGifts : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "هدیه‌های من"
        case .english:
            return "My Gifts"
        }
    }
    
    static var registerGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت هدیه"
        case .english:
            return "Gift Registering"
        }
    }
    
    static var editGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ویرایش هدیه"
        case .english:
            return "Gift Editing"
        }
    }
    
    static var allGifts : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه هدیه‌ها"
        case .english:
            return "All Gifts"
        }
    }
    
    static var allCities : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه شهر‌ها"
        case .english:
            return "All Cities"
        }
    }
    
    static var allRegions : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه منطقه‌ها"
        case .english:
            return "All Regions"
        }
    }
    
    static var category : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته بندی"
        case .english:
            return "Category"
        }
    }
    
    static var newOrSecondHand : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "وضعیت نو یا دسته ‌دو بودن"
        case .english:
            return "New or Secondhand"
        }
    }
    
    static var new : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نو"
        case .english:
            return "New"
        }
    }
    
    static var secondHand : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته‌دو"
        case .english:
            return "Secondhand"
        }
    }
    
    static var placeOfTheGift : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "محل هدیه"
        case .english:
            return "Place of the Gift"
        }
    }
    
    static var cancel : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "انصراف"
        case .english:
            return "Cancel"
        }
    }
    
    static var registered : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت شده"
        case .english:
            return "Registered"
        }
    }
    
    static var donated : String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "اهدایی"
        case .english:
            return "Donated"
        }
    }
    
}
