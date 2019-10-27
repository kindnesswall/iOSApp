//
//  RegisterGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/26/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class RegisterGiftViewModel: NSObject {
    
    var imagesUrl:[String] = []
    var apiService = ApiService(HTTPLayer())
    
    var category:Category?
    var dateStatus:DateStatus?
    var places=[Place]()
    
    var editedGift:Gift?
    var editedGiftAddress=Address()
    var giftHasNewAddress=false

    weak var delegate : RegisterGiftViewModelDelegate?
    
    class UIInputProperties {
        var titleTextViewText : String?
        var priceTextViewText : String?
        var descriptionTextViewText : String?
    }
    
    func readGiftInfo(_ giftInput:Gift) -> Gift? {
        let input:Gift = giftInput
        
        let uiProperties = delegate?.getUIInputProperties()
        
        guard let title=uiProperties?.titleTextViewText , title != "" else {
            inputErrorOnSendingGift(
                errorText: LanguageKeys.titleError.localizedString)
            return nil
        }
        input.title=title
        
        guard let categoryId=self.category?.id, categoryId != 0 else {
            inputErrorOnSendingGift(errorText: LanguageKeys.categoryError.localizedString)
            return nil
        }
        input.categoryId=categoryId
        
        guard let dateStatusId=self.dateStatus?.id else {
            inputErrorOnSendingGift(errorText: LanguageKeys.newOrUsedError.localizedString)
            return nil
        }
        if dateStatusId == 0 {
            input.isNew=true
        } else {
            input.isNew=false
        }
        
        guard let giftDescription=uiProperties?.descriptionTextViewText , giftDescription != "" else {
            inputErrorOnSendingGift(errorText: LanguageKeys.descriptionError.localizedString)
            return nil
        }
        input.description=giftDescription
        
        guard let price=uiProperties?.priceTextViewText?.castNumberToEnglish(), let priceInt = Int(price) else {
            inputErrorOnSendingGift(errorText: LanguageKeys.priceError.localizedString)
            return nil
        }
        input.price=priceInt
        
        if giftHasNewAddress {
            
            let addressObject=self.getAddress()
            guard let address=addressObject?.address else {
                inputErrorOnSendingGift(errorText: LanguageKeys.addressError.localizedString)
                return nil
            }
            guard let provinceId=addressObject?.provinceId, provinceId != 0 else {
                inputErrorOnSendingGift(errorText: LanguageKeys.addressError.localizedString)
                return nil
            }
            guard let cityId=addressObject?.cityId, cityId != 0 else {
                inputErrorOnSendingGift(errorText: LanguageKeys.addressError.localizedString)
                return nil
            }
            
            input.address=address
            input.provinceId=provinceId
            input.cityId=cityId
        } else {
            input.address=self.editedGiftAddress.address
            input.provinceId=self.editedGiftAddress.provinceId
            input.cityId=self.editedGiftAddress.cityId
        }
        
        input.giftImages=imagesUrl
        
        return input
    }
    
    func editGift(completion: @escaping (Result<Gift>) -> Void) {
        guard let gift = readGiftInfo(editedGift ?? Gift()) else {
            completion(.failure(AppError.NoData))
            return
        }
        apiService.editGift(gift) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let gift):
                self.editedGift = gift
                completion(.success(gift))
            }
        }
    }
    
    func registerGift(completion: @escaping (Result<Gift>) -> Void) {
        guard let gift = readGiftInfo(Gift()) else {
            completion(.failure(AppError.NoData))
            return
        }
        
        apiService.registerGift(gift, completion: completion)
    }
    
//    func sendGift(
//        httpMethod:HttpMethod,
//        giftId:Int? = nil,
//        responseHandler:(()->Void)?,
//        complitionHandler:(()->Void)?){
//        
//        guard let input = readGiftInfo() as? Gift else {
//            responseHandler?()
//            return
//        }
//        
//        let url:String = {
//            if let giftId=giftId {
//                return "\(URIs().gifts)/\(giftId)"
//            } else {
//                return URIs().gifts_register
//            }
//        }()
//        
//        APICall.request(url: url, httpMethod: httpMethod, input: input) { (data, response, error) in
//            
//            responseHandler?()
//            
//            guard let response = response as? HTTPURLResponse else {
//                FlashMessage.showMessage(body: LanguageKeys.weEncounterErrorTryAgain.localizedString, theme: .error)
//                return
//            }
//            if response.statusCode == APICall.OKStatus {
//                complitionHandler?()
//            } else {
//                FlashMessage.showMessage(body: LanguageKeys.weEncounterErrorTryAgain.localizedString, theme: .error)
//            }
//            
//        }
//    }
    
    func inputErrorOnSendingGift(errorText:String){
        FlashMessage.showMessage(body: errorText,theme: .warning)
    }
    
    func uploadToIranServers(image:UIImage, onSuccess:@escaping (String)->(), onFail:(()->())?) {
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageInput = ImageInput(image: imageData!, imageFormat: .jpeg)
        
        apiService.upload(imageInput: imageInput, urlSessionDelegate: self) { [weak self] (result) in
            
            switch(result){
            case .failure(let error):
                print(error)
                self?.uploadFailed()
                onFail?()
            case .success(let imageSrc):
                self?.uploadedSuccessfully()
                onSuccess(imageSrc)
            }
        }
        
    }
    
    func imageRemovedFromList(index:Int) {
        if imagesUrl.count > index {
            imagesUrl.remove(at: index)
        }
        
        apiService.cancelRequestAt(index: index)
    }
    
    func upload(image:UIImage, onSuccess:@escaping (String)->(), onFail:(()->())?) {
        
        uploadToIranServers(image: image, onSuccess: { (url) in
            onSuccess(url)
        }) {
            onFail?()
        }
    }
    
    func writeChangesToEditedGift(){
        
        guard let gift=editedGift else {
            return
        }
        
        let uiProperties = delegate?.getUIInputProperties()
        
        gift.title=uiProperties?.titleTextViewText
        gift.description=uiProperties?.descriptionTextViewText
        if let price = Int(uiProperties?.priceTextViewText?.castNumberToEnglish() ?? "0"){
            gift.price = price
        }
        
        gift.categoryTitle=self.category?.title
        gift.categoryId=self.category?.id
        
        if let dateStatusId=self.dateStatus?.id {
            if dateStatusId == 0 {
                gift.isNew=true
            } else {
                gift.isNew=false
            }
        }
        
        if giftHasNewAddress {
            
            let addressObject=self.getAddress()
            
            gift.address=addressObject?.address
            gift.provinceId=addressObject?.provinceId
            gift.cityId=addressObject?.cityId
            
        } else {
            
            gift.address=self.editedGiftAddress.address
            gift.provinceId=self.editedGiftAddress.provinceId
            gift.cityId=self.editedGiftAddress.cityId
            
        }
        
        gift.giftImages=imagesUrl
    }
    
    func readFromEditedGift(){
        guard let gift=self.editedGift else {
            return
        }
        
        let uiProperties = UIInputProperties()
        uiProperties.titleTextViewText=gift.title
        uiProperties.descriptionTextViewText=gift.description
        if let price = gift.price {
            uiProperties.priceTextViewText="\(price)"
        }else{
            uiProperties.priceTextViewText="0"
        }
        
        self.delegate?.setUIInputProperties(uiProperties: uiProperties)
        
        self.category=Category(id: gift.categoryId, title: gift.categoryTitle)
        self.delegate?.setCategoryBtnTitle(text: gift.categoryTitle)
        
        if let isNew=gift.isNew {
            if isNew {
                self.dateStatus=DateStatus(id:0,title:LanguageKeys.new.localizedString)
            } else {
                self.dateStatus=DateStatus(id: 1 , title: LanguageKeys.used.localizedString)
            }
            self.delegate?.setDateStatusBtnTitle(text: self.dateStatus?.title)
        }
        
        self.delegate?.setEditedGiftOriginalAddressLabel(text: gift.address)
        self.editedGiftAddress.address = gift.address
        self.editedGiftAddress.provinceId=gift.provinceId
        self.editedGiftAddress.cityId=gift.cityId
        
        if let giftImages = gift.giftImages {
            for giftImage in giftImages {
                self.delegate?.addUploadedImageFromEditedGift(giftImage: giftImage)
            }
        }
    }
    
    func saveDraft(){
        let draft=RegisterGiftDraft()
        
        let uiProperties = delegate?.getUIInputProperties()
        
        draft.title=uiProperties?.titleTextViewText
        draft.description=uiProperties?.descriptionTextViewText
        draft.price=Int(uiProperties?.priceTextViewText?.castNumberToEnglish() ?? "")
        
        
        draft.category=self.category
        draft.dateStatus=self.dateStatus
        draft.places=self.places
        
        guard let data=try? JSONEncoder().encode(draft) else {
            return
        }
        
        let userDefault=UserDefaults.standard
        userDefault.set(data, forKey: AppConst.UserDefaults.RegisterGiftDraft)
        userDefault.synchronize()
        
        FlashMessage.showMessage(body: LanguageKeys.draftSavedSuccessfully.localizedString, theme: .success)
    }
    
    
    func readFromDraft(){
        guard let data = UserDefaults.standard.data(forKey: AppConst.UserDefaults.RegisterGiftDraft) else {
            return
        }
        guard let draft = try? JSONDecoder().decode(RegisterGiftDraft.self, from: data) else {
            return
        }
        
        let uiProperties = UIInputProperties()
        uiProperties.titleTextViewText=draft.title
        uiProperties.descriptionTextViewText=draft.description
        uiProperties.priceTextViewText=draft.price?.description ?? ""
        self.delegate?.setUIInputProperties(uiProperties: uiProperties)
        
        if let category=draft.category {
            self.category=category
            self.delegate?.setCategoryBtnTitle(text: category.title)
        }
        
        if let dateStatus=draft.dateStatus {
            self.dateStatus=dateStatus
            self.delegate?.setDateStatusBtnTitle(text: dateStatus.title)
        }
        
        if let draftPlaces = draft.places {
            for draftPlace in draftPlaces {
                self.places.append(draftPlace)
                self.delegate?.addGiftPlaceToUIStack(place: draftPlace)
            }
        }
    }
    
    func getAddress()-> Address? {
        
        guard let provinceId=self.places.first?.id , let provinceName=self.places.first?.name else {
            return nil
        }
        
        guard self.places.count > 1 else {
            return nil
        }
        
        guard let cityId=self.places[1].id , let cityName=self.places[1].name else {
            return nil
        }
        
        
        let address="\(provinceName) \(cityName)"
        
        return Address(address:address,provinceId:provinceId,cityId:cityId)
    }
    
    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LanguageKeys.uploadedSuccessfully.localizedString,theme: .success)
    }
    
    func uploadFailed() {
        FlashMessage.showMessage(body: LanguageKeys.imageUploadingError.localizedString,theme: .warning)
    }
    
    
    func clearUploadImages() {
        apiService.cancelAllRequests()        
        imagesUrl = []
    }
}


