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
    case watchedIntro
    case watchedSelectLanguage
    case selectedCountry
    case hasInstalledBefore
    case appleLanguages
    case registerGiftDraft
    
    var key: String {
        switch self {
        case .phoneNumber:
            return AppConst.UserDefaults.PhoneNumber
        case .selectedCountry:
            return AppConst.UserDefaults.SelectedCountry
        case .appleLanguages:
            return AppConst.UserDefaults.AppleLanguages
        case .registerGiftDraft:
            return AppConst.UserDefaults.RegisterGiftDraft
        case .watchedIntro:
            return AppConst.UserDefaults.WatchedIntro
        case .watchedSelectLanguage:
            return AppConst.UserDefaults.WatchedSelectLanguage
        case .hasInstalledBefore:
            return AppConst.UserDefaults.HasInstalledBefore
        }
    }
}

class UserDefaultService {
    let uDStandard = UserDefaults.standard

    func isUserWatchedIntro() -> Bool {
        return getBool(key: .watchedIntro)
    }

    func userWatchedIntro() {
        set(.watchedIntro, value: true)
    }

    private func clearAllUserDefaultValues() {
        let domain = Bundle.main.bundleIdentifier!
        uDStandard.removePersistentDomain(forName: domain)
        uDStandard.synchronize()
    }

    func isItFirstTimeAppOpen() -> Bool {
        return !getBool(key: .hasInstalledBefore)
    }

    func appOpenForTheFirstTime() {
        set(.hasInstalledBefore, value: true)
    }

    func isLanguageSelected() -> Bool {
        return getBool(key: .watchedSelectLanguage)
    }
    
    func languageSelected() {
        set(.watchedSelectLanguage, value: true)
    }
    
    func set(_ key: UserDefaultKey, value: Any) {
        uDStandard.set(value, forKey: key.key)
        uDStandard.synchronize()
    }
    
    func getPhoneNumber() -> String? {
        return getString(key: .phoneNumber)
    }
    
    func getRegisterGiftDraftData() -> Data? {
        return getData(key: .registerGiftDraft)
    }
    
    func getSelectedContryData() -> Data? {
        return getData(key: .selectedCountry)
    }
    
    func getLanguages() -> [String] {
        return getObject(key: .appleLanguages) as? [String] ?? [""]
    }
    
    private func getObject(key: UserDefaultKey) -> Any? {
        return uDStandard.object(forKey: key.key)
    }
    private func getData(key: UserDefaultKey) -> Data? {
        return uDStandard.data(forKey: key.key)
    }
    private func getString(key: UserDefaultKey) -> String? {
        return uDStandard.string(forKey: key.key)
    }
    private func getBool(key: UserDefaultKey) -> Bool {
        return uDStandard.bool(forKey: key.key)
    }
    
    func delete(_ key: UserDefaultKey) {
        uDStandard.removeObject(forKey: key.key)
        uDStandard.synchronize()
    }
}
