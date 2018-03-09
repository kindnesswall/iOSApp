//
//  PopUpView.swift
//  LMS
//
//  Created by AmirHossein on 6/24/17.
//  Copyright © 2017 aseman. All rights reserved.
//

import UIKit

open class PopUpView: UIView {
    
    public var controller:AddPopUpController?
    
    
    open func initPopUp(){
        
    }
    
    open func popUpWillHide(){
        
    }
    
    open override func layoutSubviews() {
        self.controller?.layoutPopUp()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
