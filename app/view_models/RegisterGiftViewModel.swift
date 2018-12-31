//
//  RegisterGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/26/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import Firebase

class RegisterGiftViewModel: NSObject {
    
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
    
    func readGiftInfo() -> RegisterGiftInput? {
        var input:RegisterGiftInput = Gift()
        
        let uiProperties = delegate?.getUIInputProperties()
        
        guard let title=uiProperties?.titleTextViewText , title != "" else {
            inputErrorOnSendingGift(
                errorText: LocalizationSystem.getStr(forKey: LanguageKeys.titleError))
            return nil
        }
        input.title=title
        
        guard let categoryId=self.category?.id else {
            inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.categoryError))
            return nil
        }
        input.categoryId=categoryId
        
        guard let dateStatusId=self.dateStatus?.id else {
            inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.newOrUsedError))
            return nil
        }
        if dateStatusId == "0" {
            input.isNew=true
        } else {
            input.isNew=false
        }
        
        
        guard let giftDescription=uiProperties?.descriptionTextViewText , giftDescription != "" else {
            inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.descriptionError))
            return nil
        }
        input.description=giftDescription
        
        guard let price=uiProperties?.priceTextViewText?.castNumberToEnglish() else {
            inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.priceError))
            return nil
        }
        input.price=price
        
        
        if giftHasNewAddress {
            
            let addressObject=self.getAddress()
            guard let address=addressObject?.address else {
                inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.addressError))
                return nil
            }
            guard let cityId=addressObject?.cityId else {
                inputErrorOnSendingGift(errorText: LocalizationSystem.getStr(forKey: LanguageKeys.addressError))
                return nil
            }
            
            let regionId=addressObject?.regionId
            
            input.address=address
            input.cityId=cityId
            input.regionId=(regionId ?? "0")
            
        } else {
            
            input.address=self.editedGiftAddress.address
            input.cityId=self.editedGiftAddress.cityId
            input.regionId=self.editedGiftAddress.regionId
            
        }
        
        let giftImages=self.delegate?.getGiftImages()
        input.giftImages=giftImages
        
        return input
    }
    
    func createGiftOnFIR() {
        guard let gift = readGiftInfo() else {
            return
        }
        
        let db_ref = AppDelegate.me().FIRDB_Ref
        let childRef = db_ref.child(AppConst.FIR.Database.Gifts).childByAutoId()
        
        guard let title = gift.title,
            let images = gift.giftImages,
            let address = gift.address,
            let description = gift.description,
            let price = gift.price,
            let categoryId = gift.categoryId,
            let isNew = gift.isNew,
            let cityId = gift.cityId,
            let regionId = gift.regionId
            else {
            return
        }
        
        let info:[String:Any] = [
            "title":title,
            "address":address,
            "description":description,
            "price":price,
            "categoryId":categoryId,
            "isNew":isNew,
            "cityId":cityId,
            "regionId":regionId
        ]
        
        childRef.updateChildValues(info) { (error:Error?, dbRef:DatabaseReference) in
            if let err = error {
                print("error : \(err)")
                return
            }
            print("gift register!")
            childRef.child("giftImages").setValue(images) { (error, dbRef) in
                if let err = error {
                    print("error : \(err)")
                    return
                }
            }
        }
        
    }
    
    func sendGift(
        httpMethod:HttpCallMethod,
        giftId:String? = nil,
        responseHandler:(()->Void)?,
        complitionHandler:(()->Void)?){
        
        guard let input = readGiftInfo() as? Gift else {
            responseHandler?()
            return
        }
        
        var url=APIURLs.Gift
        if let giftId=giftId {
            url+="/\(giftId)"
        }
        
        APICall.request(url: url, httpMethod: httpMethod, input: input) { (data, response, error) in
            
            responseHandler?()
            
            //            print("Register Reply")
            //            APICall.printData(data: data)
            
            if let response = response as? HTTPURLResponse {
                print((response).statusCode)
                
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    
                    complitionHandler?()
                    
                }
            }
        }
    }
    
    func inputErrorOnSendingGift(errorText:String){
        FlashMessage.showMessage(body: errorText,theme: .warning)
    }
    
    
    func writeChangesToEditedGift(){
        
        guard let gift=editedGift else {
            return
        }
        
        let uiProperties = delegate?.getUIInputProperties()
        
        gift.title=uiProperties?.titleTextViewText
        gift.description=uiProperties?.descriptionTextViewText
        gift.price=uiProperties?.priceTextViewText?.castNumberToEnglish()
        
        gift.category=self.category?.title
        gift.categoryId=self.category?.id
        
        if let dateStatusId=self.dateStatus?.id {
            if dateStatusId == "0" {
                gift.isNew=true
            } else {
                gift.isNew=false
            }
        }
        
        if giftHasNewAddress {
            
            let addressObject=self.getAddress()
            
            let address=addressObject?.address
            let cityId=addressObject?.cityId
            let regionId=addressObject?.regionId
            
            gift.address=address
            gift.cityId=cityId?.description ?? "0"
            gift.regionId=regionId?.description ?? "0"
            
        } else {
            
            gift.address=self.editedGiftAddress.address
            gift.cityId=self.editedGiftAddress.cityId?.description
            gift.regionId=self.editedGiftAddress.regionId?.description
            
        }
        
        let giftImages=self.delegate?.getGiftImages()
        gift.giftImages=giftImages
        
    }
    
    func readFromEditedGift(){
        
        guard let gift=self.editedGift else {
            return
        }
        
        let uiProperties = UIInputProperties()
        uiProperties.titleTextViewText=gift.title
        uiProperties.descriptionTextViewText=gift.description
        uiProperties.priceTextViewText=gift.price
        self.delegate?.setUIInputProperties(uiProperties: uiProperties)
        
        self.category=Category(id: gift.categoryId, title: gift.category)
        self.delegate?.setCategoryBtnTitle(text: gift.category)
        
        
        if let isNew=gift.isNew {
            if isNew {
                self.dateStatus=DateStatus(id:"0",title:LocalizationSystem.getStr(forKey: LanguageKeys.new))
            } else {
                self.dateStatus=DateStatus(id: "1" , title: LocalizationSystem.getStr(forKey: LanguageKeys.used))
            }
            self.delegate?.setDateStatusBtnTitle(text: self.dateStatus?.title)
        }
        
        self.delegate?.setEditedGiftOriginalAddressLabel(text: gift.address)
        self.editedGiftAddress.address = gift.address
        self.editedGiftAddress.cityId=gift.cityId ?? "0"
        self.editedGiftAddress.regionId=gift.regionId ?? "0"
        
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
        
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.draftSavedSuccessfully), theme: .success)
        
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
        guard let cityId=self.places.first?.id , let cityName=self.places.first?.name else {
            return nil
        }
        
        var regionId:String?
        if places.count>1 {
            if let id=places[1].id {
                regionId=String(id)
            }
        }
        
        var address=cityName
        for i in 1..<places.count {
            if let name=places[i].name {
                address += " " + name
            }
        }
        
        return Address(address:address,cityId:String(cityId),regionId:regionId)
        
    }
    
    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.uploadedSuccessfully),theme: .success)
    }
    
    func uploadFailed() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.imageUploadingError),theme: .warning)
    }
}

protocol RegisterGiftViewModelDelegate : class {
    func getUIInputProperties() -> RegisterGiftViewModel.UIInputProperties
    func setUIInputProperties(uiProperties : RegisterGiftViewModel.UIInputProperties)
    func getGiftImages()->[String]
    
    func setCategoryBtnTitle(text:String?)
    func setDateStatusBtnTitle(text:String?)
    func setEditedGiftOriginalAddressLabel(text:String?)
    func addUploadedImageFromEditedGift(giftImage :String)
    func addGiftPlaceToUIStack(place:Place)
}
