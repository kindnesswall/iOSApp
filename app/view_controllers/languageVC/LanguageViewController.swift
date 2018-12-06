//
//  LanguageViewController.swift
//  app
//
//  Created by Hamed.Gh on 11/27/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension LanguageViewController : LanguageViewDelegate {
    func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTextOf(label: String, button: String) {
        lbl.text = label
        okBtn.titleLabel?.text = button
    }
    
    func set(textAlignment: NSTextAlignment) {
        lbl.textAlignment = textAlignment
    }
    
    func show(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
}

class LanguageViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var okBtn: UIButton!
        
    let languageViewModel:LanguageViewModel = LanguageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = languageViewModel
        pickerView.dataSource = languageViewModel
        
        languageViewModel.delegate = self
    }

    @IBAction func okBtnClicked(_ sender: Any) {

        languageViewModel.selectLanguage(index:pickerView.selectedRow(inComponent: 0))
    }
}
