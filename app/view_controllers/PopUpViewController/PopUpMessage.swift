//
//  PopUpMessage.swift
//  app
//
//  Created by AmirHossein on 3/26/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class PopUpMessage {
    
    static func showPopUp(nibClass:AnyClass,data:Any?=nil,animation:PopUpViewController.PopUpAnimation,declineHandler : ((Any?)->Void)?,submitHandler : ((Any?)->Void)?){
        
        let controller=PopUpViewController()
        controller.modalPresentationStyle = .overCurrentContext
        
        controller.nibClass=nibClass
        controller.data=data
        controller.popUpAnimation=animation
        
        controller.setSubmitHandler(submitHandler)
        controller.setDeclineHandler(declineHandler)
        
        self.presentCotroller(controller: controller)
        
        
    }
    
    private static func presentCotroller(controller:UIViewController) {
        guard var rootViewController = AppDelegate.me().window?.rootViewController else{
            return
        }
        if let presentedVC=rootViewController.presentedViewController {
            rootViewController=presentedVC
        }
        rootViewController.present(controller, animated: false, completion: nil)
    }
}

