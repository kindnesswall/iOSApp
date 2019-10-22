//
//  ProfileViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewModel : UploadImageVM {
    
    var username: String?
    
    override init() {
        
    }
    
    func uploadThe(image:UIImage, onSuccess:@escaping ()->(), onFail:(()->())?) {
        
        self.upload(image: image, onSuccess: { [weak self] in
            self?.updateUser(name: self?.username, completion: { (result) in
                switch result {
                case .failure(_):
                    onFail?()
                case .success(_):
                    onSuccess()
                }
            })
        }, onFail: onFail)
        
    }
    
    func updateUser(name: String?, completion: @escaping (Result<Void>)-> Void) {
        let profile = UserProfile.Input(name: name, image: imageUrl)
        apiService.updateUser(profile: profile) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(_):
                completion(.success(Void()))
            }
        }
    }
    
    func getProfile(completion: @escaping (Result<UserProfile>)-> Void) {
        if let userId = KeychainSwift().get(AppConst.KeyChain.USER_ID), let id = Int(userId) {
            apiService.getUserProfile(userId: id) { [weak self](result) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let userProfile):
                    self?.imageUrl = userProfile.image
                    self?.username = userProfile.name
                    completion(.success(userProfile))
                }
            }
        }
    }
    
}
