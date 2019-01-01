//
//  UploadImageView.swift
//  app
//
//  Created by AmirHossein on 2/14/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class UploadImageView: UIView {
    
    weak var delegate : UploadImageViewDelegate?

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!

    @IBAction func cancelBtnAction(_ sender: Any) {
        self.delegate?.imageCanceled(imageView: self)
    }
    
    func uploadFinished() {
        shadowView.hide()
        progressLabel.hide()
    }
    
}

protocol UploadImageViewDelegate : class {
    func imageCanceled(imageView:UploadImageView)
}
