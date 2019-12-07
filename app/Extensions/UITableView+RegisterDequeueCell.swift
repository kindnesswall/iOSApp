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

    func register<CellType:UITableViewCell>(type:CellType.Type) {
        self.register(CellType.nib, forCellReuseIdentifier: CellType.identifier)
    }
    
    func dequeue<CellType:UITableViewCell>(type:CellType.Type,for indexPath: IndexPath) -> CellType {
        return (self.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType) ?? CellType()
    }
}
