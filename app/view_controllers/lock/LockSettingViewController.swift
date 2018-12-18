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
    
    @IBOutlet weak var changePasscodeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppDelegate.me().isPasscodeSaved() {
            turnPasscodeOnOffBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.TurnPasscodeOff), for: UIControl.State.normal)
            changePasscodeBtn.show()
        }else{
            turnPasscodeOnOffBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.TurnPasscodeOn), for: UIControl.State.normal)
            changePasscodeBtn.hide()
        }
        
        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.PasscodeLock)

    }
    
    func setPasscode() {
        let controller = LockViewController()
        controller.mode = .SetPassCode
        self.tabBarController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func changePasscodeBtnClicked(_ sender: Any) {
        setPasscode()
    }
    
    @IBAction func turnPassOnOffBtnClicked(_ sender: Any) {
        if AppDelegate.me().isPasscodeSaved() {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.TurnPasscodeOff), style: UIAlertAction.Style.destructive, handler: { [weak self] (action) in
                
                self?.keychain.delete(AppConstants.PassCode)
                self?.turnPasscodeOnOffBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.TurnPasscodeOn), for: UIControl.State.normal)
                self?.changePasscodeBtn.hide()

            }))
            
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            setPasscode()
        }
    }
    
}
