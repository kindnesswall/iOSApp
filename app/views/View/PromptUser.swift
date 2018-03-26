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
    
    
    @IBAction func acceptBtnClicked(_ sender: Any) {
        
        self.controller?.submitPopUp()
    }
    
    @IBAction func rejectBtnClicked(_ sender: Any) {
        
        
        self.controller?.declinePopUp()

    }
    
    override func initPopUpView() {
        if let txt:String = controller?.data as? String {
            self.message.text = txt
        }
    }

}
