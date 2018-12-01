//
//  UITableView+RegisterCell.swift
//  ResanehAval
//
//  Created by Hamed.Gh on 12/8/1396 AP.
//  Copyright © 1396 Aseman. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func register<cellType:UITableViewCell>(type:cellType.Type) {
        self.register(cellType.nib, forCellReuseIdentifier: cellType.identifier)
    }
}
