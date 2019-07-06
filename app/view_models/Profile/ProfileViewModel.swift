//
//  ProfileViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

protocol ProfileViewModelDelegate : class {
    func updateUploadImage(percent:Int)
    
}

class ProfileViewModel:NSObject {
    
    var sessions : [URLSession]=[]
    var tasks : [URLSessionUploadTask]=[]
    weak var delegate : ProfileViewModelDelegate?
    var imageUrl:String?
    lazy var apiRequest = ApiRequest(HTTPLayer())

    override init() {
        
    }
    
    func getProfile(completion: @escaping (Result<UserProfile>)-> Void) {
        if let userId = KeychainSwift().get(AppConst.KeyChain.USER_ID), let id = Int(userId) {
            apiRequest.getUserProfile(userId: id) { (result) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let userProfile):
                    completion(.success(userProfile))
                }
            }
        }
    }
    
    func upload(image:UIImage, onSuccess:@escaping (String)->(), onFail:(()->())?) {
        
        uploadToIranServers(image: image, onSuccess: { (url) in
            onSuccess(url)
        }) {
            onFail?()
        }
    }
    
    func uploadToIranServers(image:UIImage, onSuccess:@escaping (String)->(), onFail:(()->())?) {
        
        let imageData = image.jpegData(compressionQuality: 1)
        let imageInput = ImageInput(image: imageData!, imageFormat: .jpeg)
        
        APICall.uploadImage(
            url: URIs().image_upload,
            input: imageInput,
            sessions: &sessions,
            tasks: &tasks,
            delegate: self) { [weak self] (data, response, error) in
                
                ApiUtility.watch(data: data)
                
                if let imageSrc=ApiUtility.convert(data: data, to: ImageOutput.self)?.address {
                    self?.uploadedSuccessfully()
                    onSuccess(imageSrc)
                } else {
                    self?.uploadFailed()
                    onFail?()
                }
        }
    }
    
    func uploadedSuccessfully() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.uploadedSuccessfully),theme: .success)
    }
    
    func uploadFailed() {
        FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.imageUploadingError),theme: .warning)
    }
}
