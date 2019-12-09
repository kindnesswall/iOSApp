//
//  UICollectionView + RegisterCell.swift
//  app
//
//  Created by Amir Hossein on 12/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<CellType: UICollectionViewCell>(cellType: CellType.Type) {
        self.register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    func dequeue<CellType: UICollectionViewCell>(type: CellType.Type, for indexPath: IndexPath) -> CellType {
        return (self.dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType) ?? CellType()
    }
}
