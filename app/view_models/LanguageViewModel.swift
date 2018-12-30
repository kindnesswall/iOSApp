//
//  LanguageViewModel.swift
//  app
//
//  Created by Hamed.Gh on 12/6/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

protocol LanguageViewDelegate {
    func show(alert:UIAlertController) -> ()
    func setTextOf(label:String,button:String)
    func set(textAlignment:NSTextAlignment)
    func dismissViewController()
}

class LanguageViewModel: NSObject {
    let keychain = KeychainSwift()
    let datasource = [AppLanguage.Persian, AppLanguage.English]
    let datasourceToShow = ["فارسی", "English"]
    var delegate:LanguageViewDelegate?
    
    var tabBarIsInitialized : Bool!

    func showAlert(for index:Int) {
        var title:String!
        var message:String!
        var okBtn:String!
        var cancelBtn:String!
        
        if datasource[index] == AppLanguage.English{
            title = "Close App";
            message = "To switch language, open the app after closing";
            okBtn = "OK";
            cancelBtn = "Cancel";
        }else{
            title = "بستن برنامه";
            message = "برای تغییر زبان باید پس از بسته شدن برنامه آن را مجدد اجرا کنید";
            okBtn = "باشه";
            cancelBtn = "بی‌خیال";
        }
        
        let alert = UIAlertController(
            title:title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: okBtn, style: UIAlertAction.Style.default, handler: { (action) in
            
            if let _=self.keychain.get(AppConst.KeyChain.Authorization) {
                if AppLanguage.getLanguage() == AppLanguage.English {
                    UIApplication.shared.shortcutItems = [
                        UIApplicationShortcutItem(
                            type: "ir.kindnesswall.publicusers.DonateGift",
                            localizedTitle: "ثبت هدیه",
                            localizedSubtitle: "",
                            icon: UIApplicationShortcutIcon(type: .favorite),
                            userInfo: nil)
                    ]
                }else if AppLanguage.getLanguage() == AppLanguage.Persian {
                    UIApplication.shared.shortcutItems = [
                        UIApplicationShortcutItem(
                            type: "ir.kindnesswall.publicusers.DonateGift",
                            localizedTitle: "Donate a Gift",
                            localizedSubtitle: "",
                            icon: UIApplicationShortcutIcon(type: .favorite),
                            userInfo: nil)
                    ]
                }
                
            } else {
                UIApplication.shared.shortcutItems = []
            }
            
            self.languageHasChangedTo(selectedLanguage: self.datasource[index])
            
        }))
        
        alert.addAction(UIAlertAction(title: cancelBtn, style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                
            })
        }))
        
        self.delegate?.show(alert: alert)
    }
    
    private func languageHasChangedTo(selectedLanguage: String){
        LocalizationSystem.sharedInstance.setLanguage(languageCode: selectedLanguage)
        exit(0)
    }
    
    func selectLanguage(index:Int) {
        UserDefaults.standard.set(true, forKey: AppConst.UserDefaults.WATCHED_SELECT_LANGUAGE)
        UserDefaults.standard.synchronize()
        
        if datasource[index] == AppLanguage.getLanguage() {
            
            languageHasNotChanged()
            
        } else {
            showAlert(for: index)
        }
    }
    
    private func languageHasNotChanged(){
        
        if tabBarIsInitialized {
            self.delegate?.dismissViewController()
        } else {
            AppDelegate.me().showTabbarIntro()
        }
    }
}

extension LanguageViewModel:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if datasource[row] == AppLanguage.English {
            
            self.delegate?.setTextOf(
                label:"Please select your preferred language:",
                button:"OK"
            )
            self.delegate?.set(textAlignment: .left)
            
        }else{
            
            self.delegate?.setTextOf(
                label:"لطفا زبان مورد نظر خود را انتخاب کنید:",
                button: "تایید"
            )
            self.delegate?.set(textAlignment: .right)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasourceToShow[row]
    }
}
