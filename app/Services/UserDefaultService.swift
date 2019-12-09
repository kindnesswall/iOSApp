//
//  UserDefaultService.swift
//  app
//
//  Created by Hamed Ghadirian on 08.12.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

enum UserDefaultKey {
    case phoneNumber
//    case watchedIntro
//    case watchedSelectLanguage
    case selectedCountry
//    case firstInstall
    case appleLanguages
    case registerGiftDraft
}

class UserDefaultService {
    let uDStandard = UserDefaults.standard

    func isUserWatchedIntro() -> Bool {
        return uDStandard.bool(forKey: AppConst.UserDefaults.WatchedIntro)
    }

    func userWatchedIntro() {
        uDStandard.set(true, forKey: AppConst.UserDefaults.WatchedIntro)
        uDStandard.synchronize()
    }

    private func clearAllUserDefaultValues() {
        let domain = Bundle.main.bundleIdentifier!
        uDStandard.removePersistentDomain(forName: domain)
        uDStandard.synchronize()
    }

    func isItFirstTimeAppOpen() -> Bool {
        return uDStandard.object(forKey: AppConst.UserDefaults.FirstInstall) == nil
    }

    func appOpenForTheFirstTime() {
        uDStandard.set(false, forKey: AppConst.UserDefaults.FirstInstall)
        uDStandard.synchronize()
    }
    
    func watchedSelectLanguage() {
        UserDefaults.standard.set(true, forKey: AppConst.UserDefaults.WatchedSelectLanguage)
        UserDefaults.standard.synchronize()
    }

    func isLanguageSelected() -> Bool {
        return uDStandard.bool(forKey: AppConst.UserDefaults.WatchedSelectLanguage)
    }
    
    func languageSelected() {
        uDStandard.set(true, forKey: AppConst.UserDefaults.WatchedSelectLanguage)
        uDStandard.synchronize()
    }
    
    func set(_ key: UserDefaultKey, value: Any) {
        switch key {
        case .phoneNumber:
            uDStandard.set(value, forKey: AppConst.UserDefaults.PhoneNumber)
        case .selectedCountry:
            uDStandard.set(value, forKey: AppConst.UserDefaults.SelectedCountry)
        case .registerGiftDraft:
            uDStandard.set(value, forKey: AppConst.UserDefaults.RegisterGiftDraft)
        case .appleLanguages:
            uDStandard.set(value, forKey: AppConst.UserDefaults.AppleLanguages)
        }
        uDStandard.synchronize()
    }
    
    func getString(_ key: UserDefaultKey) -> String? {
        switch key {
        case .phoneNumber:
            return uDStandard.string(forKey: AppConst.UserDefaults.PhoneNumber)
        case .selectedCountry:
            return uDStandard.string(forKey: AppConst.UserDefaults.SelectedCountry)
        default:
            return nil
        }
    }
    
    func getData(_ key: UserDefaultKey) -> Data? {
        switch key {
        case .registerGiftDraft:
            return uDStandard.data(forKey: AppConst.UserDefaults.RegisterGiftDraft)
        default:
            return nil
        }
    }
    
    func getLanguages() -> [String] {
        return (UserDefaults.standard.object(forKey: AppConst.UserDefaults.AppleLanguages) as? [String]) ?? [""]
    }
    
    func delete(_ key: UserDefaultKey) {
        switch key {
        case .registerGiftDraft:
            uDStandard.removeObject(forKey: AppConst.UserDefaults.RegisterGiftDraft)
        case .selectedCountry:
            uDStandard.removeObject(forKey: AppConst.UserDefaults.SelectedCountry)
        case .phoneNumber:
            uDStandard.removeObject(forKey: AppConst.UserDefaults.PhoneNumber)
        case .appleLanguages:
            uDStandard.removeObject(forKey: AppConst.UserDefaults.AppleLanguages)
        }
        uDStandard.synchronize()
    }
}
