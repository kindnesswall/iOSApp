//
//  RegisterGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/26/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class RegisterGiftViewModel: NSObject {

    var imagesUrl: [String] {
        return delegate?.getUploadedImagesUrls() ?? []
    }
    var apiService = ApiService(HTTPLayer())
    let userDefaultService = UserDefaultService()
    
    var category: Category?
    var dateStatus: DateStatus?
    var places=[Place]()

    var editedGift: Gift?
    var editedGiftAddress: Address?
    var giftHasNewAddress=false

    weak var delegate: RegisterGiftViewModelDelegate?

    class UIInputProperties {
        var titleTextViewText: String?
        var priceTextViewText: String?
        var descriptionTextViewText: String?
    }

    func readGiftInfo(_ giftInput: Gift) -> (Gift?, String?) {
        let input: Gift = giftInput

        let uiProperties = delegate?.getUIInputProperties()

        guard let title=uiProperties?.titleTextViewText, title != "" else {
            return (nil, LanguageKeys.titleError.localizedString)
        }
        input.title=title

        guard let categoryId=self.category?.id, categoryId != 0 else {
            return (nil, LanguageKeys.categoryError.localizedString)
        }
        input.categoryId=categoryId

        guard let dateStatusId=self.dateStatus?.id else {
            return (nil, LanguageKeys.newOrUsedError.localizedString)
        }
        input.isNew=dateStatusId == 0

        guard let giftDescription=uiProperties?.descriptionTextViewText, giftDescription != "" else {
            return (nil, LanguageKeys.descriptionError.localizedString)
        }
        input.description=giftDescription

        guard let price=uiProperties?.priceTextViewText?.castNumberToEnglish(), let priceInt = Int(price) else {
            return (nil, LanguageKeys.priceError.localizedString)
        }
        input.price=priceInt
        
        guard let countryId = AppCountry.countryId else {
            return (nil, LanguageKeys.countryError.localizedString)
        }
        input.countryId = countryId

        if giftHasNewAddress {

            let addressObject=self.getAddress()
            guard addressObject?.address != nil else {
                return (nil, LanguageKeys.addressError.localizedString)
            }
            guard let provinceId=addressObject?.provinceId, provinceId != 0 else {
                return (nil, LanguageKeys.addressError.localizedString)
            }
            guard let cityId=addressObject?.cityId, cityId != 0 else {
                return (nil, LanguageKeys.addressError.localizedString)
            }

            input.provinceId=provinceId
            input.provinceName=addressObject?.province

            input.cityId=cityId
            input.cityName=addressObject?.city

            input.regionName=addressObject?.region
            input.regionId=addressObject?.regionId

        } else {
            input.provinceId=self.editedGiftAddress?.provinceId
            input.provinceName=editedGiftAddress?.province

            input.cityId=self.editedGiftAddress?.cityId
            input.cityName=editedGiftAddress?.city

            input.regionId=self.editedGiftAddress?.regionId
            input.regionName=editedGiftAddress?.region
        }
        if imagesUrl.count <= 0 {
            return (nil, LanguageKeys.noImageError.localizedString)
        }
        input.giftImages=imagesUrl

        return (input, nil)
    }

    func editGift(completion: @escaping (Result<Gift>) -> Void) {
        let (giftFromUI, errorMessage) = readGiftInfo(editedGift ?? Gift())
        guard let gift = giftFromUI else {
            completion(.failure(AppError.clientSide(message: errorMessage ?? "")))
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
        let (giftFromUI, errorMessage) = readGiftInfo(editedGift ?? Gift())
        guard let gift = giftFromUI else {
            completion(.failure(AppError.clientSide(message: errorMessage ?? "")))
            return
        }

        apiService.registerGift(gift, completion: completion)
    }

    func upload(image: UIImage, onSuccess:@escaping (String) -> Void, onFail:(() -> Void)?) -> URLSessionUploadTask? {

        let imageData = image.jpegData(compressionQuality: 1)
        let imageInput = ImageInput(image: imageData!, imageFormat: .jpeg)

        return apiService.upload(imageInput: imageInput, urlSessionDelegate: self) { [weak self] (result) in

            switch result {
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

    func writeChangesToEditedGift() {

        guard let gift=editedGift else {
            return
        }

        let uiProperties = delegate?.getUIInputProperties()

        gift.title=uiProperties?.titleTextViewText
        gift.description=uiProperties?.descriptionTextViewText
        if let price = Int(uiProperties?.priceTextViewText?.castNumberToEnglish() ?? "0") {
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

            gift.provinceId=addressObject?.provinceId
            gift.cityId=addressObject?.cityId
            gift.regionId=addressObject?.cityId

            gift.provinceName=addressObject?.province
            gift.cityName=addressObject?.city
            gift.regionName=addressObject?.region

        } else {

            gift.provinceId=self.editedGiftAddress?.provinceId
            gift.cityId=self.editedGiftAddress?.cityId
            gift.regionId=self.editedGiftAddress?.regionId

            gift.provinceName=self.editedGiftAddress?.province
            gift.cityName=self.editedGiftAddress?.city
            gift.regionName=self.editedGiftAddress?.region
        }

        gift.giftImages=imagesUrl
    }

    func readFromEditedGift() {
        guard let gift=self.editedGift else {
            return
        }

        let uiProperties = UIInputProperties()
        uiProperties.titleTextViewText=gift.title
        uiProperties.descriptionTextViewText=gift.description
        if let price = gift.price {
            uiProperties.priceTextViewText="\(price)"
        } else {
            uiProperties.priceTextViewText="0"
        }

        self.delegate?.setUIInputProperties(uiProperties: uiProperties)

        self.category=Category(id: gift.categoryId, title: gift.categoryTitle)
        self.delegate?.setCategoryBtnTitle(text: gift.categoryTitle)

        if let isNew=gift.isNew {
            if isNew {
                self.dateStatus=DateStatus(id: 0, title: LanguageKeys.new.localizedString)
            } else {
                self.dateStatus=DateStatus(id: 1, title: LanguageKeys.used.localizedString)
            }
            self.delegate?.setDateStatusBtnTitle(text: self.dateStatus?.title)
        }

        let address = Address(province: gift.provinceName, city: gift.cityName, region: gift.regionName)
        self.delegate?.setEditedGiftOriginalAddressLabel(text: address.address)

        self.editedGiftAddress = Address(province: gift.provinceName, city: gift.cityName, region: gift.regionName)
        self.editedGiftAddress?.provinceId=gift.provinceId
        self.editedGiftAddress?.cityId=gift.cityId
        self.editedGiftAddress?.regionId=gift.regionId

        if let giftImages = gift.giftImages {
            for giftImage in giftImages {
                self.delegate?.addUploadedImageFromEditedGift(giftImage: giftImage)
            }
        }
    }

    func saveDraft() {
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

        UserDefaultService().set(.registerGiftDraft, value: data)

        FlashMessage.showMessage(body: LanguageKeys.draftSavedSuccessfully.localizedString, theme: .success)
    }

    func readFromDraft() {
        guard let data = userDefaultService.getRegisterGiftDraftData() else {
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

    func getAddress() -> Address? {

        let province = places.count > 0 ? places[0] : nil
        let city = places.count > 1 ? places[1] : nil
        let region = places.count > 2 ? places[2] : nil

        let address=Address(province: province, city: city, region: region)

        return address
    }

    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LanguageKeys.uploadedSuccessfully.localizedString, theme: .success)
    }

    func uploadFailed() {
        FlashMessage.showMessage(body: LanguageKeys.imageUploadingError.localizedString, theme: .warning)
    }

}
