//
//  RGVC + uploading images.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController

extension RegisterGiftViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let selectedImage = info[.originalImage] as? UIImage
        
        
        if let selectedImage=selectedImage {
            
            
            let cropViewController = CropViewController(image: selectedImage)
            cropViewController.delegate = self
            
            
            picker.dismiss(animated: true, completion: nil)
            
            present(cropViewController, animated: false, completion: nil)
            
            
            
            
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension RegisterGiftViewController : CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //        self.croppedRect = cropRect
        //        self.croppedAngle = angle
        //        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        
        uploadImage(selectedImage: image)
        self.dismiss(animated: false, completion: nil)
    }
    
    //    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    ////        self.croppedRect = cropRect
    ////        self.croppedAngle = angle
    ////        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    //        uploadImage(selectedImage: image)
    //    }
    
    func uploadImage(selectedImage: UIImage) {
        //        if let token=UserDefaults.standard.string(forKey: AppConstants.Authorization) {
        
        let uploadedImageView=addUploadImageView(image: selectedImage)
        
        APICall.uploadImage(url: APIURLs.Upload, image: selectedImage, sessions: &uploadedImageView.sessions, tasks: &uploadedImageView.tasks, delegate: self) { [weak self] (data, response, error) in
            
            //            if let response = response as? HTTPURLResponse {
            //                print((response).statusCode)
            //
            //                if response.statusCode >= 200 && response.statusCode <= 300 {
            //                    FlashMessage.showMessage(body: "آپلود با موفقیت انجام شد",theme: .success)
            //                }else{
            //                    FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
            //                }
            //            }
            //
            //            guard error==nil else {
            //                FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
            //                return
            //            }
            
            APIRequest.logReply(data: data)
            
            if let imageSrc=APIRequest.readJsonData(data: data, outputType: ImageUpload.self)?.imageSrc {
                
                guard let uploadIndex=self?.findIndexOfUploadedImage(task: uploadedImageView.getTask()) else {
                    return
                }
                
                self?.imageViewUploadingHasFinished(uploadImageView: self?.uploadedImageViews[uploadIndex], imageSrc: imageSrc)
                
                FlashMessage.showMessage(body: AppLiteralForMessages.uploadedSuccessfully,theme: .success)
            } else {
                FlashMessage.showMessage(body: AppLiteralForMessages.imageUploadingError,theme: .warning)
            }
            
        }
        
    }
    
    func addUploadImageView(imageSrc:String) -> UploadImageView{
        let uploadedImageView=initUploadImageView()
        if let url=URL(string:imageSrc) {
            uploadedImageView.imageView.sd_setImage(with: url, completed: nil)
        }
        return uploadedImageView
    }
    
    func addUploadImageView(image:UIImage) -> UploadImageView{
        let uploadedImageView=initUploadImageView()
        uploadedImageView.imageView.image=image
        return uploadedImageView
    }
    
    func initUploadImageView()-> UploadImageView {
        let uploadedImageView=NibLoader.loadViewFromNib(name: "UploadImageView", owner: self, nibType: UploadImageView.self) as! UploadImageView
        uploadedImageView.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        uploadedImageView.delegate=self
        
        self.uploadedImageViews.append(uploadedImageView)
        self.uploadedImageStack.addArrangedSubview(uploadedImageView)
        
        return uploadedImageView
    }
    
    func imageViewUploadingHasFinished(uploadImageView:UploadImageView?,imageSrc:String){
        uploadImageView?.shadowView.isHidden=true
        uploadImageView?.progressLabel.isHidden = true
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
        self.uploadedImageViews[uploadIndex].progressLabel.text = "٪" + UIFunctions.CastNumberToPersian(input: percent)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}


extension RegisterGiftViewController:UINavigationControllerDelegate{

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

