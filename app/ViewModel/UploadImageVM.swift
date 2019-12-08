//
//  UploadImageVM.swift
//  app
//
//  Created by Hamed Ghadirian on 31.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

protocol UploadImageVMDelegate: class {
    func updateUploadImage(percent: Int)
}

class UploadImageVM: NSObject {

    weak var delegate: UploadImageVMDelegate?
    var apiService = ApiService(HTTPLayer())

    var imageUrl: String?

    func upload(image: UIImage, onSuccess:@escaping ()->Void, onFail:(()->Void)?) {

        let imageData = image.jpegData(compressionQuality: 1)
        let imageInput = ImageInput(image: imageData!, imageFormat: .jpeg)

        apiService.upload(imageInput: imageInput, urlSessionDelegate: self) { [weak self] (result) in

            switch(result) {
            case .failure(let error):
                print(error)
                self?.uploadFailed()
                onFail?()
            case .success(let imageSrc):
                self?.uploadedSuccessfully()
                self?.imageUrl = imageSrc
                onSuccess()
            }
        }
    }

    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LanguageKeys.uploadedSuccessfully.localizedString, theme: .success)
    }

    func uploadFailed() {
        FlashMessage.showMessage(body: LanguageKeys.imageUploadingError.localizedString, theme: .warning)
    }

}

extension UploadImageVM: URLSessionTaskDelegate {

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
