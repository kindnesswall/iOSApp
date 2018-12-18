//
//  LockViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import AudioToolbox
import CryptoSwift
import KeychainSwift

class LockViewController: UIViewController {

    enum Mode {
        case SetPassCode
        case CheckPassCode
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var mainTitleLbl: UILabel!
    
    @IBOutlet var circles: [CircledDotView]!
    
    @IBOutlet var numbers: [RoundButton]!
    
    @IBOutlet weak var fingerPrintBtn: UIButton!
    
    var onPasscodeCorrect:(()->())?
    
    let touchMe = BiometricIDAuth()
    
    let keychain = KeychainSwift()
    var isCancelable:Bool = true
    var passwordCounter:Int = -1 {
        didSet{
            if passwordCounter >= 4 {
                
            }
        }
    }
    
    let Salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"

    var mode:Mode = .SetPassCode
    
    var isReEnterPasscode:Bool = false
    var passcode:[Int] = [Int]()
    var reEnterPasscode:[Int] = [Int]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func bioAuthBtnClicked(_ sender: Any) {
        touchMe.authenticateUser() { [weak self] in
            self?.onPasscodeCorrect?()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func clearCircles() {
        for i in 0...(circles.count - 1) {
            circles[i].mainColor = .black
        }
    }
    
    func afterLastPasscodeKeyPressed() {
        switch mode {
        case .SetPassCode:
            if isReEnterPasscode {
                for i in 0...(circles.count - 1) {
                    if passcode[i] != reEnterPasscode[i]{
                        passwordCounter = -1
                        clearCircles()
                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        
                        mainTitleLbl.text = LocalizationSystem.getStr(forKey: LanguageKeys.EnterAPasscode)
                        isReEnterPasscode = false
                        
                        passcode.removeAll()
                        reEnterPasscode.removeAll()
                        return
                    }
                }
                savePasscode()
                self.dismiss(animated: true, completion: nil)
            }else{
                passwordCounter = -1
                clearCircles()
                
                mainTitleLbl.text = LocalizationSystem.getStr(forKey: LanguageKeys.ReEnterNewPasscode)
                isReEnterPasscode = true
            }
        case .CheckPassCode:
            if isPasscodeCorrect(){
                self.onPasscodeCorrect?()
                self.dismiss(animated: true, completion: nil)
            }else{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                passwordCounter = -1
                clearCircles()
                passcode.removeAll()
            }
        }
    }
    var mutex: Int = 0
    @IBAction func numbersClicked(_ sender: Any) {
        print("Number \((sender as AnyObject).tag) clicked.")
        
        guard self.mutex == 0 else {
            return
        }
        
        passwordCounter += 1
        circles[passwordCounter].mainColor = .lightGray
        
        if let code = (sender as AnyObject).tag {
            switch mode {
            case .SetPassCode:
                if isReEnterPasscode {
                    reEnterPasscode.append( code)
                }else{
                    passcode.append( code)
                }
            case .CheckPassCode:
                passcode.append( code)
            }
        }
        if passwordCounter >= circles.count-1 {
            self.mutex = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in 
               self?.afterLastPasscodeKeyPressed()
                self?.mutex = 0
            })
        }
    }
    
    func savePasscode() {
        self.keychain.set(hashPasscode(), forKey: AppConstants.PassCode)
    }
    
    func hashPasscode()-> String {
        var pass:String = ""
        for i in 0...passcode.count-1 {
            pass = pass + "\(passcode[i])"
        }
        return "\(pass).\(Salt)".sha256()
    }
    
    func isPasscodeCorrect() -> Bool {
        guard passcode.count == circles.count else { return false }
        
        var pass:String = ""
        for i in 0...passcode.count-1 {
            pass = pass + "\(passcode[i])"
        }
        
        let passCodeHash:String = "\(pass).\(Salt)".sha256()
        let lastSavedPasscodeHash:String = self.keychain.get(AppConstants.PassCode) ?? ""
        if passCodeHash == lastSavedPasscodeHash {
            return true
        }
        
        return false
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        if passwordCounter >= 0 {
            
            switch mode{
            case .CheckPassCode:
                passcode.remove(at: passwordCounter)
                
            case .SetPassCode:
                if isReEnterPasscode {
                    reEnterPasscode.remove(at: passwordCounter)
                }else{
                    passcode.remove(at: passwordCounter)
                }
            }
            
            circles[passwordCounter].mainColor = .black
            passwordCounter -= 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !isCancelable {
            cancelBtn.hide()
        }
        
        switch touchMe.biometricType() {
        case .faceID:
            fingerPrintBtn.setImage(UIImage(named: "faceIcon"),  for: .normal)
            fingerPrintBtn.setImage(UIImage(named: "faceIcon_dark"),  for: .highlighted)
        default:
            fingerPrintBtn.setImage(UIImage(named: "touch_icon"),  for: .normal)
            fingerPrintBtn.setImage(UIImage(named: "touch_icon_dark"),  for: .highlighted)
        }
        
        fingerPrintBtn.isHidden = !touchMe.canEvaluatePolicy()

    }
}
