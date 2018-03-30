//
//  UINavigationBar + config.swift
//  app
//
//  Created by AmirHossein on 3/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setDefaultStyle(){
        self.tintColor=AppColor.tintColor
        self.titleTextAttributes=[NSAttributedStringKey.font:AppFont.getBoldFont(size: 17),NSAttributedStringKey.foregroundColor:AppColor.tintColor]
        
    }
}
