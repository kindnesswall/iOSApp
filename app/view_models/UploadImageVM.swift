//
//  UploadImageVM.swift
//  app
//
//  Created by Hamed Ghadirian on 31.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit


protocol UploadImageVMDelegate : class {
    func updateUploadImage(percent:Int)
}

class UploadImageVM : NSObject {

    weak var delegate : UploadImageVMDelegate?

    var sessions : [URLSession]=[]
    var tasks : [URLSessionUploadTask]=[]
    var imageUrl: String?
    
    func upload(image:UIImage, onSuccess:@escaping ()->(), onFail:(()->())?) {
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageInput = ImageInput(image: imageData!, imageFormat: .jpeg)
        
        APICall.uploadImage(
            url: URIs().image_upload,
            input: imageInput,
            sessions: &sessions,
            tasks: &tasks,
            delegate: self) { [weak self] (data, response, error) in
                
                ApiUtility.watch(data: data)
                
                if let imageSrc=ApiUtility.convert(data: data, to: ImageOutput.self)?.address {
                    self?.uploadedSuccessfully()
                    self?.imageUrl = imageSrc
                    onSuccess()
                } else {
                    self?.uploadFailed()
                    onFail?()
                }
        }
    }
    
    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.uploadedSuccessfully),theme: .success)
    }
    
    func uploadFailed() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.imageUploadingError),theme: .warning)
    }
    
}


extension UploadImageVM:URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("byte :: \(bytesSent) in : \(totalBytesSent) from : \(totalBytesExpectedToSend)")
        
        var percent = Int(Float(totalBytesSent * 100)/Float(totalBytesExpectedToSend))
        if percent == 100 {
            percent = 99
        }
        
        self.delegate?.updateUploadImage(percent: percent)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}
