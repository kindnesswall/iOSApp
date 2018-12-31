//
//  RGVC+vm delegate.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

extension RegisterGiftViewController : RegisterGiftViewModelDelegate {
    
    
    func setUIInputProperties(uiProperties: RegisterGiftViewModel.UIInputProperties) {
        descriptionTextView.text = uiProperties.descriptionTextViewText
        priceTextView.text = uiProperties.priceTextViewText
        titleTextView.text = uiProperties.titleTextViewText
    }
    
    func getUIInputProperties() -> RegisterGiftViewModel.UIInputProperties {
        let uiProperties = RegisterGiftViewModel.UIInputProperties()
        uiProperties.descriptionTextViewText = descriptionTextView.text
        uiProperties.priceTextViewText = priceTextView.text
        uiProperties.titleTextViewText = titleTextView.text
        return uiProperties
        
    }
    
    func getGiftImages()->[String] {
        if AppDelegate.me().isIranSelected() {
            var giftImages=[String]()
            for uploadedImageView in self.uploadedImageViews {
                if let src=uploadedImageView.imageSrc {
                    giftImages.append(src)
                }
            }
            return giftImages
        }else{
            return imagesUrl
        }
    }
    
    
    func setCategoryBtnTitle(text: String?) {
        self.categoryBtn.setTitle(text, for: .normal)
    }
    
    func setDateStatusBtnTitle(text: String?) {
        self.dateStatusBtn.setTitle(text, for: .normal)
    }
    
    func setEditedGiftOriginalAddressLabel(text: String?) {
        self.editedGiftOriginalAddress.text=text
    }
    
    func addUploadedImageFromEditedGift(giftImage: String) {
        let uploadImageView=self.addUploadImageView(imageSrc: giftImage)
        self.imageViewUploadingHasFinished(uploadImageView: uploadImageView, imageSrc: giftImage)
    }
    
    func addGiftPlaceToUIStack(place: Place) {
        self.addGiftPlace(place: place)
    }
    
}
