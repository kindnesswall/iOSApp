//
//  RegisterGiftViewModelDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

protocol RegisterGiftViewModelDelegate : class {
    func getUIInputProperties() -> RegisterGiftViewModel.UIInputProperties
    func setUIInputProperties(uiProperties : RegisterGiftViewModel.UIInputProperties)
    
    func setCategoryBtnTitle(text:String?)
    func setDateStatusBtnTitle(text:String?)
    func setEditedGiftOriginalAddressLabel(text:String?)
    func addUploadedImageFromEditedGift(giftImage :String)
    func addGiftPlaceToUIStack(place:Place)
    func updateUploadImage(index:Int,percent:Int)
}
