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
        uploadImage(selectedImage: image)
        self.dismiss(animated: false, completion: nil)
    }
    
    func uploadImage(selectedImage: UIImage) {
        let _=addUploadImageView(image: selectedImage)
        let index = uploadedImageViews.count - 1
        
        self.vm.upload(
            image: selectedImage,
            onSuccess: { [weak self] (imageUrl) in
            self?.imageViewUploadingHasFinished(uploadImageView: self?.uploadedImageViews[index], imageSrc: imageUrl)
            }, onFail: { [weak self] in
                self?.removeImage(index: index)
                self?.vm.imageRemovedFromList(index: index)
        })
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
        uploadImageView?.uploadFinished()
        
        vm.imagesUrl.append(imageSrc)
    }
    
    func clearUploadedImages(){
        if AppDelegate.me().isIranSelected() {
            for uploadedImageView in self.uploadedImageViews {
//                uploadedImageView.cancelUploading()
                uploadedImageView.removeFromSuperview()
            }
            for session in vm.sessions {
                session.invalidateAndCancel()
            }
            for task in vm.tasks {
                task.cancel()
            }
            
            self.uploadedImageViews=[]
        }else{
            
        }
    }
}

extension RegisterGiftViewController : UploadImageViewDelegate {
 
    func imageCanceled(imageView: UploadImageView) {
        guard let index=findIndexOfUploadedImage(imageView:imageView) else {
            return
        }
        removeImage(index: index)
        vm.imageRemovedFromList(index: index)
    }
    
    func removeImage(index:Int) {
        self.uploadedImageViews[index].removeFromSuperview()
        self.uploadedImageViews.remove(at: index)
    }
    
    func findIndexOfUploadedImage(imageView: UploadImageView)->Int?{
        
        for (index,view) in uploadedImageViews.enumerated() {
            if view === imageView {
                return index
            }
        }
        return nil
        
    }
}

