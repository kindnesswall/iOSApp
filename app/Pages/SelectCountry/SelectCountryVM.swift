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
    func dismissViewController()
}

class SelectCountryVM: NSObject {
    let keychain = KeychainSwift()
    let datasource = AppConst.Country.allCases
    var tabBarIsInitialized : Bool!
    var delegate:SelectCountryDelegate?
    
    func countrySelected(index:Int) {
        
        AppCountry.setCountry(current: datasource[index])
        
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
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppCountry.getText(country: datasource[row])
    }
}

