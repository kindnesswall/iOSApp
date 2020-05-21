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
    @BindingWrapper var loadingState: ViewLoadingState = .loading(.initial)
    
    weak var delegate: SelectCountryDelegate?
    let apiService = ApiService(HTTPLayer())
    
    func getCountries() {
        let data =
        """
        [{
        "id":82,
        "name":"Germany",
        "phoneCode": "049",
        "localization": "de"
        }]
        """.data(using: .utf8)

        if let countries = ApiUtility.convert(data: data, to: [Country].self) {
                self.datasource = countries
        }
//        loadingState = .loading(.initial)
//        apiService.checkYoutube { [weak self] result in
//            switch result {
//            case .failure(let error):
//                self?.loadingState = .failed(error)
//            case .success(let countries):
//                self?.datasource = countries
//                self?.loadingState = .success
//            }
//        }
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
