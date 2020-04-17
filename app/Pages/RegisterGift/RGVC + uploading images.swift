//
//  RGVC + uploading images.swift
//  app
//
//  Created by AmirHossein on 3/23/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import CropViewController

extension RegisterGiftViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let selectedImage = info[.originalImage] as? UIImage else {
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

extension RegisterGiftViewController: CropViewControllerDelegate {

    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        uploadImage(selectedImage: image)
        self.dismiss(animated: false, completion: nil)
    }

    func uploadImage(selectedImage: UIImage) {
        let imageView = addUploadImageView(image: selectedImage)

        let task = self.vm.upload(
            image: selectedImage,
            onSuccess: { [weak imageView] (imageUrl) in
                imageView?.uploadFinished(url: imageUrl)
            }, onFail: { [weak self, weak imageView] in
                guard let imageView = imageView else {return}
                self?.imageCanceled(imageView: imageView)
        })
        imageView.uploadStarted(task: task)
    }

    func addUploadImageView(imageSrc: String) {
        let imageView=initUploadImageView()
        imageView.download(url: imageSrc)
    }

    func addUploadImageView(image: UIImage) -> UploadImageView {
        let imageView=initUploadImageView()
        imageView.display(image: image)
        return imageView
    }

    func initUploadImageView() -> UploadImageView {
        let imageView = NibLoader.load(type: UploadImageView.self)!
        
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive=true
        imageView.delegate=self

        self.uploadedImageViews.append(imageView)
        self.uploadedImageStack.addArrangedSubview(imageView)

        return imageView
    }

    func clearUploadedImages() {
        for each in uploadedImageViews {
            each.cancelUploadAndRemove()
        }
        uploadedImageViews=[]
    }
}

extension RegisterGiftViewController: UploadImageViewDelegate {

    func imageCanceled(imageView: UploadImageView) {
        imageView.cancelUploadAndRemove()
        uploadedImageViews.removeAll { $0 === imageView }
    }
    
    func imageView(ofTask task: URLSessionUploadTask) -> UploadImageView? {
        uploadedImageViews.first { [weak task] in
            guard let task = task else { return false }
            return $0.same(task: task)
        }
    }
}
