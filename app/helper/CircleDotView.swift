//
//  CircleDotView.swift
//  app
//
//  Created by Hamed.Gh on 12/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CircledDotView: UIView {
    
    @IBInspectable var mainColor: UIColor = .white {
        didSet {
            print("mainColor was set here")
            self.draw()
        }
    }
    @IBInspectable var ringColor: UIColor = .black {
        didSet {
            print("bColor was set here")
            self.draw()
        }
    }
    @IBInspectable var ringThickness: CGFloat = 4 {
        didSet { print("ringThickness was set here")
            self.draw()
        }
    }
    
    var rect:CGRect?
    
    @IBInspectable var isSelected: Bool = true
    
    func draw() {
        if let rect = rect {
            self.draw(rect)
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.rect = rect
        
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        layer.addSublayer(shapeLayer)
        
        if (isSelected) {
            drawRingFittingInsideView(rect: rect)
        }
    }
    
    internal func drawRingFittingInsideView(rect: CGRect) {
        self.rect = rect

        let hw: CGFloat = ringThickness / 2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw, dy: hw))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ringColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
}
