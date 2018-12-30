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
        self.tintColor=AppConst.Resource.Color.Tint
        self.titleTextAttributes=[NSAttributedString.Key.font:AppConst.Resource.Font.getBoldFont(size: 17),NSAttributedString.Key.foregroundColor:AppConst.Resource.Color.Tint]
        
    }
}
