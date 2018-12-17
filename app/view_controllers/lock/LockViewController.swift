//
//  LockViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import AudioToolbox

class LockViewController: UIViewController {

    @IBOutlet weak var mainTitleLbl: UILabel!
    
    @IBOutlet var circles: [CircledDotView]!
    
    @IBOutlet var numbers: [RoundButton]!
    
    @IBOutlet weak var fingerPrintBtn: UIButton!
    
    var passwordCounter:Int = -1 {
        didSet{
            if passwordCounter >= 4 {
                
            }
        }
    }
    enum Mode {
        case SetPassCode
        case CheckPassCode
    }
    var mode:Mode = .SetPassCode
    
    var isReEnterPasscode:Bool = false
    var passcode:[Int] = [Int]()
    var reEnterPasscode:[Int] = [Int]()
    
    func clearCircles() {
        for i in 0...((circles.count ?? 1) - 1) {
            circles[i].mainColor = .black
        }
    }
    @IBAction func numbersClicked(_ sender: Any) {
        print("Number \((sender as AnyObject).tag) clicked.")
        
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
            switch mode {
            case .SetPassCode:
                if isReEnterPasscode {
                    for i in 0...((circles.count ?? 1) - 1) {
                        if passcode[i] != reEnterPasscode[i]{
                            passwordCounter = -1
                            clearCircles()
                            
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                            
                            mainTitleLbl.text = "Enter a passcode"
                            isReEnterPasscode = false
                            
                            passcode.removeAll()
                            reEnterPasscode.removeAll()
                            return
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }else{
                    passwordCounter = -1
                    clearCircles()
                    
                    mainTitleLbl.text = "Re-enter your new passcode"
                    isReEnterPasscode = true
                }
            case .CheckPassCode:
                var i = 2
            }
            
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
}
