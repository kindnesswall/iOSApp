//
//  RoundButton.swift
//  app
//
//  Created by Hamed.Gh on 12/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var highlightedBackgroundImageColor: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            refreshColor(color: highlightedBackgroundImageColor, state: UIControl.State.highlighted)
        }
    }
    
    @IBInspectable var normalBackgroundImageColor: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            refreshColor(color: normalBackgroundImageColor, state: UIControl.State.normal)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2 {
        didSet {
            refreshBorder(borderWidth: borderWidth)
        }
    }
    
    @IBInspectable var customBorderColor: UIColor = UIColor.init (red: 0, green: 122/255, blue: 255/255, alpha: 1){
        didSet {
            refreshBorderColor(colorBorder: customBorderColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        refreshCorners(value: cornerRadius)
        
        refreshColor(color: normalBackgroundImageColor, state: UIControl.State.normal)
        refreshColor(color: highlightedBackgroundImageColor, state: UIControl.State.normal)
        
        refreshBorderColor(colorBorder: customBorderColor)
        refreshBorder(borderWidth: borderWidth)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshBorder(borderWidth: CGFloat) {
        layer.borderWidth = borderWidth
    }
    
    func refreshBorderColor(colorBorder: UIColor) {
        layer.borderColor = colorBorder.cgColor
    }

    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: 1, height: 1), true, 0.0
        )
        color.setFill()
        UIRectFill(
            CGRect(x: 0, y: 0, width: 1, height: 1)
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func refreshColor(color: UIColor, state: UIControl.State) {
        let image = createImage(color: color)
        setBackgroundImage(image, for: state)
        clipsToBounds = true
    }

//    var highlightedColorHandle: UInt8 = 0
    
//    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
//        self.setBackgroundImage(createImage(color: color), for: state)
//    }
    
//    @IBInspectable
//    var highlightedColor: UIColor? {
//        get {
//            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
//                return color
//            }
//            return nil
//        }
//        set {
//            if let color = newValue {
//                self.setBackgroundColor(color, for: .highlighted)
////                objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            } else {
//                self.setBackgroundImage(nil, for: .highlighted)
////                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
    
}
