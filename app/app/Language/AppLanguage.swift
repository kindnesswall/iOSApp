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
    
    
    //MARK: - Utilities
    
    static func getNumberString(number:String)->String{
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return number.CastNumberToPersian()
        case .english:
            return number
        }
    }
    
    static func getTextAlignment()->NSTextAlignment{
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return .right
        case .english:
            return .left
        }
    }
    
}


