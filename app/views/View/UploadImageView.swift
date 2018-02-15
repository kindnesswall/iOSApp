//
//  UploadImageView.swift
//  app
//
//  Created by AmirHossein on 2/14/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class UploadImageView: UIView {
    
    var uploadSession:Foundation.URLSession?
    var uploadTask:URLSessionDataTask?

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
