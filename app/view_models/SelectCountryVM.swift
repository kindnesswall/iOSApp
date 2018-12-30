//
//  SelectCountryVM.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

protocol SelectCountryDelegate {
//    func show(alert:UIAlertController) -> ()
    func dismissViewController()
}

class SelectCountryVM: NSObject {
    let keychain = KeychainSwift()
    let datasource = [AppConst.Country.IRAN, AppConst.Country.OTHERS]
    var tabBarIsInitialized : Bool!
    var delegate:SelectCountryDelegate?
    
    func countrySelected(index:Int) {
        UserDefaults.standard.set(datasource[index], forKey: AppConst.UserDefaults.SELECTED_COUNTRY)
        UserDefaults.standard.synchronize()
        
        delegate?.dismissViewController()
    }
}

extension SelectCountryVM:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if datasource[row] == AppLanguage.English {
            
//            self.delegate?.setTextOf(
//                label:"Please select your preferred language:",
//                button:"OK"
//            )
//            self.delegate?.set(textAlignment: .left)
            
        }else{
            
//            self.delegate?.setTextOf(
//                label:"لطفا زبان مورد نظر خود را انتخاب کنید:",
//                button: "تایید"
//            )
//            self.delegate?.set(textAlignment: .right)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row]
    }
}

