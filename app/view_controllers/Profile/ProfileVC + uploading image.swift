//
//  ProfileVC + uploading image.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController
import Kingfisher

extension ProfileViewController:UIImagePickerControllerDelegate{
    
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

extension ProfileViewController:CropViewControllerDelegate{
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        uploadImage(selectedImage: image)
        self.dismiss(animated: false, completion: nil)
    }
    
    func uploadImage(selectedImage: UIImage) {
        
        avatarImageView.image=selectedImage
        uploadProgressView.isHidden = false
        uploadView.isHidden = true
        
        self.vm?.upload(
            image: selectedImage,
            onSuccess: { [weak self] (imageUrl) in
                self?.imageViewUploadingHasFinished(imageSrc: imageUrl)
            }, onFail: {
                self.setDefaultViews()
        })
    }
    
    func imageViewUploadingHasFinished(imageSrc:String){
        self.vm?.imageUrl = imageSrc
        self.setDefaultViews()
    }
}

extension ProfileViewController:UINavigationControllerDelegate{
    
}

extension ProfileViewController:ProfileViewModelDelegate{
    func updateUploadImage(percent: Int) {
        uploadProgressLbl.text = "٪" + String(AppLanguage.getNumberString(number: String(percent)))
    }
}
