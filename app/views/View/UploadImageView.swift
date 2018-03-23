//
//  UploadImageView.swift
//  app
//
//  Created by AmirHossein on 2/14/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class UploadImageView: UIView {
    
    
    var sessions : [URLSession?]=[]
    var tasks : [URLSessionUploadTask?]=[]
    
    func getTask()->URLSessionUploadTask? {
        
        guard let task = self.tasks.first else {
            return nil
        }
        return task
    }
    
    var imageSrc:String?
    
    weak var delegate : UploadImageViewDelegate?

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
    
    func cancelUploading(){
        APICall.stopAndClearUploadRequests(sessions: &sessions, tasks: &tasks)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        self.cancelUploading()
        
        self.delegate?.imageCanceled(imageView: self)
    }
    
}

protocol UploadImageViewDelegate : class {
    func imageCanceled(imageView:UploadImageView)
}
