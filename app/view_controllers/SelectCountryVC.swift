//
//  SelectCountryVC.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension SelectCountryVC:SelectCountryDelegate{
    func dismissViewController() {
        AppDelegate.me().checkLanguageSelectedOrNot()
    }
    
    func show(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

class SelectCountryVC: UIViewController {
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = vm
        picker.dataSource = vm
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let descriptionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Please select your country:"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var okBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onSelectBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var vm:SelectCountryVM = {
        let vm = SelectCountryVM()
        vm.delegate = self
        return vm
    }()
    
    @objc func onSelectBtnClicked() {
        vm.countrySelected(index:pickerView.selectedRow(inComponent: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        view.addSubview(pickerView)
        view.addSubview(descriptionLbl)
        view.addSubview(okBtn)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        pickerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        pickerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        descriptionLbl.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: -16).isActive = true
        descriptionLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        okBtn.topAnchor.constraint(equalTo: self.pickerView.bottomAnchor, constant: -16).isActive = true
        okBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}


