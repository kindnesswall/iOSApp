//
//  AppViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 26.10.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation
import KeychainSwift

class AppViewModel {
    let keychain = KeychainSwift()
    var apiService = ApiService(HTTPLayer())
    let uDStandard = UserDefaults.standard
    
    func saveToKeychain(_ authOutput:AuthOutput) {
        if let userID = authOutput.token.userID?.description, let token = authOutput.token.token {
            
            keychain.set(userID, forKey: AppConst.KeyChain.USER_ID)
            keychain.set(AppConst.KeyChain.BEARER + " " + token, forKey: AppConst.KeyChain.Authorization)
        }
        
        
        keychain.set(authOutput.isAdmin, forKey: AppConst.KeyChain.IsAdmin)
        keychain.set(authOutput.isCharity, forKey: AppConst.KeyChain.IsCharity)
    }
    
    func clearUserSensitiveData() {
        let keychain = KeychainSwift()
        
        keychain.delete(AppConst.KeyChain.USER_ID)
        keychain.delete(AppConst.KeyChain.Authorization)
        keychain.delete(AppConst.KeyChain.IsAdmin)
    }
    
    func isUserLogedIn() -> Bool {
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            return true
        }
        return false
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func saveOrDelete(value:String?,key:String) {
        if let value = value {
            keychain.set(value, forKey: key)
        } else {
            keychain.delete(key)
        }
    }
    
    func registerPush(){
        registerPush(deviceIdentifier: keychain.get(AppConst.KeyChain.DeviceIdentifier),pushToken: keychain.get(AppConst.KeyChain.PushToken))
    }

    func registerPush(deviceIdentifier:String?,pushToken:String?){
        guard isUserLogedIn(),
            let deviceIdentifier = deviceIdentifier,
            let pushToken = pushToken
        else { return }

        let input = PushNotificationRegister(deviceIdentifier: deviceIdentifier, devicePushToken: pushToken)

        self.apiService.registerPush(input: input) { _ in }
    }
    
    public func isPasscodeSaved() -> Bool {
        if let _ = keychain.get(AppConst.KeyChain.PassCode) {
            return true
        }
        return false
    }
    
    func isIranSelected() -> Bool {
        let selectedCountry = uDStandard.string(forKey: AppConst.UserDefaults.SELECTED_COUNTRY)
        return selectedCountry == AppConst.Country.IRAN
    }
    
    func isUserWatchedIntro() -> Bool {
        return uDStandard.bool(forKey: AppConst.UserDefaults.WATCHED_INTRO)
    }
    
    func userWatchedIntro() {
        uDStandard.set(true, forKey: AppConst.UserDefaults.WATCHED_INTRO)
        uDStandard.synchronize()
    }
    
    private func clearAllUserDefaultValues(){
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
        keychain.clear()
    }
    
    func isNotSelectedCountryBefore() -> Bool {
        return uDStandard.string(forKey: AppConst.UserDefaults.SELECTED_COUNTRY) == nil
    }
    
    func isLanguageSelected() -> Bool {
        return uDStandard.bool(forKey: AppConst.UserDefaults.WATCHED_SELECT_LANGUAGE)
    }
    
    func saveDeviceIdentifierAndPushToken(pushToken:String?){
        
        let deviceIdentifier = UIDevice.current.identifierForVendor?.uuidString
        saveOrDelete(value: deviceIdentifier, key: AppConst.KeyChain.DeviceIdentifier)
        saveOrDelete(value: pushToken, key: AppConst.KeyChain.PushToken)
        
        print("Device Identifier: \(deviceIdentifier ?? "")")
        print("Push Token: \(pushToken ?? "")")
        
        registerPush(deviceIdentifier: deviceIdentifier, pushToken: pushToken)
    }
}
