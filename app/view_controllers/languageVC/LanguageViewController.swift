//
//  LanguageViewController.swift
//  app
//
//  Created by Hamed.Gh on 11/27/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lbl: UILabel!
    
    private let datasource = [AppLanguage.Persian, AppLanguage.English]
    private let datasourceToShow = ["فارسی", "English"]
    
    @IBOutlet weak var okBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self

    }

    @IBAction func okBtnClicked(_ sender: Any) {

        UserDefaults.standard.set(true, forKey: AppConstants.WATCHED_SELECT_LANGUAGE)
        
        if datasource[pickerView.selectedRow(inComponent: 0)] == AppLanguage.getLanguage() {
            AppDelegate.me().showTabbarIntro()
        } else {
            
            var title:String!
            var message:String!
            var okBtn:String!
            var cancelBtn:String!
            
            if datasource[pickerView.selectedRow(inComponent: 0)] == AppLanguage.English{
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
                
                LocalizationSystem.sharedInstance.setLanguage(languageCode: self.datasource[self.pickerView.selectedRow(inComponent: 0)])
                
                exit(0)
            }))
            
            alert.addAction(UIAlertAction(title: cancelBtn, style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
}

extension LanguageViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if datasource[row] == AppLanguage.English {
            lbl.text = "Please select your preferred language:"
            lbl.textAlignment = .left
            okBtn.titleLabel?.text = "OK"
        }else{
            lbl.text = "لطفا زبان مورد نظر خود را انتخاب کنید:"
            lbl.textAlignment = .right
            okBtn.titleLabel?.text = "تایید"
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasourceToShow[row]
    }
}
