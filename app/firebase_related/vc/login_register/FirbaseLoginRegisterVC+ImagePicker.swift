//
//  FirbaseLoginRegisterVC+ImagePicker.swift
//  SwiftMessenger
//
//  Created by Hamed.Gh on 12/23/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import Foundation
import UIKit

extension FirbaseLoginRegisterVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @objc func handleImageTap(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
            print(editedImage.size)
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        if let img = selectedImage {
            profileImageView.image = img
        }
        
        print("did finish picking")
        print("size : \(selectedImage?.size)")
        picker.dismiss(animated: true, completion: nil)

    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("image picker did cancel")
        picker.dismiss(animated: true, completion: nil)
    }
    
}
