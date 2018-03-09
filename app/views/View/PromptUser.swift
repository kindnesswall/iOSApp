//
//  spamPopUp.swift
//  LMS
//
//  Created by AmirHossein on 6/28/17.
//  Copyright © 2017 aseman. All rights reserved.
//

import UIKit


class PromptUser: PopUpView {

    @IBOutlet weak var message: UILabel!
    
    var onAcceptClouser:( ()->Void)?
    var onRejectClouser:( ()->Void)?
    
    @IBAction func acceptBtnClicked(_ sender: Any) {
        self.onAcceptClouser?()
        if let stopUploadClouser = onAcceptClouser {
            stopUploadClouser()
        }
        self.controller?.hidePopUp()
    }
    
    @IBAction func rejectBtnClicked(_ sender: Any) {
        
        if let onRejectClouser = onRejectClouser {
            onRejectClouser()
        }
        self.controller?.hidePopUp()

    }
    
    override func initPopUp() {
        if let submitComplition=controller?.submitComplition as? ()->Void {
            onAcceptClouser = submitComplition
        }
        
        if let closeComplition=controller?.closeComplition as? ()->Void {
            onRejectClouser = closeComplition
        }
        if let txt:String = controller?.data as? String {
            self.message.text = txt
        }
    }

}
