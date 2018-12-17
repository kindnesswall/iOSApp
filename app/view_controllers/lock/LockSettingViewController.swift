//
//  LockSettingViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/17/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class LockSettingViewController: UIViewController {

    let keychain = KeychainSwift()

    @IBOutlet weak var turnPasscodeOnOffBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isPasscodeSaved() {
            turnPasscodeOnOffBtn.titleLabel?.text = "Turn Passcode Off"
        }else{
            turnPasscodeOnOffBtn.titleLabel?.text = "Turn Passcode On"
        }
    }
    
    @IBAction func turnPassOnOffBtnClicked(_ sender: Any) {
        if isPasscodeSaved() {
            let alert = UIAlertController(
                title:LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_title),
                message: LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_text),
                preferredStyle: UIAlertController.Style.actionSheet)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { (action) in
                
            }))
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let controller = LockViewController()
            self.tabBarController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func isPasscodeSaved() -> Bool {
        if let _ = keychain.get(AppConstants.PassCode) {
            return true
        }
        return false
    }
}
