//
//  RGVC + uploading images.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController
import Kingfisher

extension RegisterGiftViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else{
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        let cropViewController = CropViewController(image: selectedImage)
        cropViewController.delegate = self
        
        picker.dismiss(animated: true, completion: nil)
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension RegisterGiftViewController : CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        if AppDelegate.me().isIranSelected() {
            uploadImage(selectedImage: image)
        }else{
            uploadImageToFIR(image: image)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func uploadImageToFIR(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let fileName = NSUUID().uuidString + dateFormatterGet.string(from: Date())
        
        let storage_ref = AppDelegate.me().FIRStorage_Ref
        let childRef = storage_ref.child(AppConst.FIR.Storage.Gift_Images).child("\(fileName).jpg")
        
        let uploadTask = childRef.putData(imageData, metadata: nil, completion: { [weak self](storageMetaData, error) in
            
            if error != nil {
                print("storage error : \(error)")
                self?.uploadFailed()
                return
            }
            print("upload successfully!")
            self?.uploadedSuccessfully()
            childRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    print("Uh-oh, an error occurred in upload!")
                    return
                }
                self?.imagesUrl.append(downloadURL.absoluteString)
                
                print("url: " + downloadURL.absoluteString)
                //                    completionHandler(downloadURL.absoluteString)
            })
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            if let fraction = snapshot.progress?.fractionCompleted {
                let precent = Int(Double(fraction) * 100)
                print(precent)
            }else{
                print("no fraction")
            }
        }
    }
    
    func uploadImage(selectedImage: UIImage) {
        let uploadedImageView=addUploadImageView(image: selectedImage)
        
        APICall.uploadImage(
            url: APIURLs.Upload,
            image: selectedImage,
            sessions: &uploadedImageView.sessions,
            tasks: &uploadedImageView.tasks,
            delegate: self) { [weak self] (data, response, error) in
            
            ApiUtility.watch(data: data)
            
            if let imageSrc=ApiUtility.convert(data: data, to: ImageUpload.self)?.imageSrc {
                
                guard let uploadIndex=self?.findIndexOfUploadedImage(task: uploadedImageView.getTask()) else {
                    return
                }
                
                self?.imageViewUploadingHasFinished(uploadImageView: self?.uploadedImageViews[uploadIndex], imageSrc: imageSrc)
                
                self?.uploadedSuccessfully()
            } else {
                self?.uploadFailed()
            }
            
        }
        
    }
    
    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.uploadedSuccessfully),theme: .success)
    }
    
    func uploadFailed() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.imageUploadingError),theme: .warning)
    }
    
    func addUploadImageView(imageSrc:String) -> UploadImageView{
        let uploadedImageView=initUploadImageView()
        if let url=URL(string:imageSrc) {
            uploadedImageView.imageView.kf.setImage(with: url)
        }
        return uploadedImageView
    }
    
    func addUploadImageView(image:UIImage) -> UploadImageView{
        let uploadedImageView=initUploadImageView()
        uploadedImageView.imageView.image=image
        return uploadedImageView
    }
    
    func initUploadImageView()-> UploadImageView {
        let uploadedImageView = NibLoader.loadViewFromNib(
            name: UploadImageView.identifier,
            owner: self,
            nibType: UploadImageView.self) as! UploadImageView
        uploadedImageView.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        uploadedImageView.delegate=self
        
        self.uploadedImageViews.append(uploadedImageView)
        self.uploadedImageStack.addArrangedSubview(uploadedImageView)
        
        return uploadedImageView
    }
    
    func imageViewUploadingHasFinished(uploadImageView:UploadImageView?,imageSrc:String){
        uploadImageView?.shadowView.hide()
        uploadImageView?.progressLabel.hide()
        uploadImageView?.imageSrc=imageSrc
    }
    
    
    func findIndexOfUploadedImage(task:URLSessionTask?)->Int?{
        
        guard let task = task else {
            return nil
        }
        
        for i in 0..<self.uploadedImageViews.count {
            if self.uploadedImageViews[i].getTask()==task {
                return i
            }
        }
        return nil
        
    }
    
    func clearUploadedImages(){
        for uploadedImageView in self.uploadedImageViews {
            uploadedImageView.cancelUploading()
            uploadedImageView.removeFromSuperview()
        }
        self.uploadedImageViews=[]
    }
}

extension RegisterGiftViewController:URLSessionTaskDelegate{
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("byte :: \(bytesSent) in : \(totalBytesSent) from : \(totalBytesExpectedToSend)")
        
        var percent = Int(Float(totalBytesSent * 100)/Float(totalBytesExpectedToSend))
        if percent == 100 {
            percent = 99
        }
        
        guard let uploadIndex=findIndexOfUploadedImage(task: task) else {
            return
        }
        
        self.uploadedImageViews[uploadIndex].progressLabel.text = "٪" + String(AppLanguage.getNumberString(number: String(percent)))
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}

extension RegisterGiftViewController : UploadImageViewDelegate {
 
    func imageCanceled(imageView: UploadImageView) {
        guard let index=findIndexOfUploadedImage(imageView:imageView) else {
            return
        }
        self.uploadedImageViews[index].removeFromSuperview()
        self.uploadedImageViews.remove(at: index)
    }
    
    func findIndexOfUploadedImage(imageView: UploadImageView)->Int?{
        
        for i in 0..<self.uploadedImageViews.count {
            if self.uploadedImageViews[i]===imageView {
                return i
            }
        }
        return nil
        
    }
}

