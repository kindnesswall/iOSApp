//
//  UIButton + Font.swift
//  app
//
//  Created by Amir Hossein on 2/14/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String, color: UIColor, font: UIFont) {
        let text = NSAttributedString(string: title, attributes: [.foregroundColor: color, .font: font])
        self.setAttributedTitle(text, for: .normal)
    }
}
