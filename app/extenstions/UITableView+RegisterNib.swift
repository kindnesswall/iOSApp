//
//  UITableView+RegisterNib.swift
//  app
//
//  Created by AmirHossein on 2/9/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerNib(type:AnyClass,nib:String){
        let bundle=Bundle(for: type)
        let nibFile = UINib(nibName: nib, bundle: bundle)
        self.register(nibFile, forCellReuseIdentifier: nib)
    }
}
