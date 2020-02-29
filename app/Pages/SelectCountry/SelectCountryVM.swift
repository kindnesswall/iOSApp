//
//  SelectCountryVM.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

protocol SelectCountryDelegate: class {
    func dismissViewController()
}

class SelectCountryVM: NSObject {
    @BindingWrapper var datasource = [Country]()
    var tabBarIsInitialized: Bool!
    weak var delegate: SelectCountryDelegate?
    let apiService = ApiService(HTTPLayer())
    
    func fetch() {
        apiService.getCountries { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let countries):
                self.datasource = countries
            }
        }
    }

    func countrySelected(index: Int) {

        AppCountry.setCountry(datasource[index])

        delegate?.dismissViewController()
    }
}

extension SelectCountryVM: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row].name
    }
}
