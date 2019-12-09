//
//  ProgressBarView.swift
//  app
//
//  Created by Hamed.Gh on 12/6/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {

    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!

    var progress: Float = 0 {
        willSet(newValue) {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.simpleShape()
    }

    func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.clear.cgColor

        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 2
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.strokeEnd = 0.0

        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }

    private func createCirclePath() {
        let width = self.frame.width / 2
        let height = self.frame.height / 2
        let center = CGPoint(x: width, y: height)
        bgPath.addArc(withCenter: center, radius: width / CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
}
